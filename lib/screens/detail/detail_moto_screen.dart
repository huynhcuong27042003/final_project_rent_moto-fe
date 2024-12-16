// ignore_for_file: avoid_print, use_build_context_synchronously, annotate_overrides
import 'package:final_project_rent_moto_fe/screens/map/location_of-moto.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/get_user_data_service.dart';
import 'package:final_project_rent_moto_fe/services/bookingMoto/addbookingService.dart';
import 'package:final_project_rent_moto_fe/services/fcm/fcm_service.dart';
import 'package:final_project_rent_moto_fe/services/notification/notification_service.dart';
import 'package:final_project_rent_moto_fe/services/promo/apply_promo_service.dart';
import 'package:final_project_rent_moto_fe/services/promoByCompany/applyPromoByCompany.dart';
import 'package:final_project_rent_moto_fe/widgets/detail_moto/detail_moto.dart';
import 'package:final_project_rent_moto_fe/widgets/detail_moto/detail_moto_appbar.dart';
import 'package:final_project_rent_moto_fe/widgets/modals/calendar_rental.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class DetailMotoScreen extends StatefulWidget {
  final Map<String, dynamic> motorcycle; // Thêm một tham số để nhận dữ liệu

  const DetailMotoScreen({super.key, required this.motorcycle});
  @override
  State<DetailMotoScreen> createState() => _DetailMotoScreenState();
}

class _DetailMotoScreenState extends State<DetailMotoScreen> {
  // Nhận dữ liệu từ constructor
  final ApplyPromoByCompanyService promoService = ApplyPromoByCompanyService();
  String _selectedPickupOption = 'self_pickup'; // Default pickup option

  late DateTime pickupDate; // Khai báo ngày nhận
  late DateTime returnDate; // Khai báo ngày trả
  String pickupTime = "21:00";
  String returnTime = "22:00";
  int totalAmount = 0;
  int originalTotalAmount = 0;
  DateTime? pickupDateTime;
  DateTime? returnDateTime;
  final _addBookingService = AddBookingService();
  LatLng? _mapCoordinates;
  String? appliedPromoCode;
  Map<String, dynamic>? userData;
  final FCMService fcmService = FCMService();
  double priceIsDiscount = 0.0;
  double originalPrice = 0.0;
  double percentage = 0.0;
  void initState() {
    super.initState();
    pickupDate = DateTime.now();
    returnDate = pickupDate.add(const Duration(days: 1));
    _updateDateTimes(); // Cập nhật giá trị pickupDateTime và returnDateTime ngay khi khởi tạo
    _calculateTotalAmount();
    _fetchCoordinates();
    String email = widget.motorcycle['email'] ?? 'Không có email';
    getUserData(email);
    _applyPromo();
  }

  Future<void> _applyPromo() async {
    try {
      var motorcycleId = widget.motorcycle['id']; // Assuming you have an 'id'
      double discountedPrice = await promoService.applyPromotion(motorcycleId);
      setState(() {
        percentage = discountedPrice != originalPrice
            ? ((originalPrice - discountedPrice) / originalPrice) * 100
            : 0.0;
        priceIsDiscount = discountedPrice;
      });
    } catch (e) {
      print("Error applying promotion: $e");
    }
  }

  // Phương thức cập nhật pickupDateTime và returnDateTime
  void _updateDateTimes() {
    List<String> pickupTimeParts = pickupTime.split(":");
    List<String> returnTimeParts = returnTime.split(":");

    pickupDateTime = DateTime(
      pickupDate.year,
      pickupDate.month,
      pickupDate.day,
      int.parse(pickupTimeParts[0]), // Giờ
      int.parse(pickupTimeParts[1]),
    );

    returnDateTime = DateTime(
      returnDate.year,
      returnDate.month,
      returnDate.day,
      int.parse(returnTimeParts[0]), // Giờ
      int.parse(returnTimeParts[1]),
    );
  }

  // Tính tổng tiền
  void _calculateTotalAmount() async {
    if (pickupDateTime != null && returnDateTime != null) {
      // Tính số ngày thuê
      int rentalDays = returnDateTime!.difference(pickupDateTime!).inDays;

      // Lấy giá thuê từ thông tin xe
      var info = widget.motorcycle['informationMoto'] ?? {};
      String priceXe = info['price'].toString();
      // Lấy giá đã áp dụng khuyến mãi từ service
      try {
        double discountedPrice = await promoService
            .applyPromotion(widget.motorcycle['id']); // Lấy id của xe máy
        setState(() {
          // Nếu có khuyến mãi, dùng giá đã giảm, nếu không dùng giá gốc
          priceXe = discountedPrice.toString();
          // Tính tổng tiền sau khuyến mãi
          int numberPirceXe = discountedPrice.toInt();
          totalAmount = (rentalDays * numberPirceXe);
          originalTotalAmount = totalAmount;
        });
      } catch (e) {
        // Nếu không áp dụng khuyến mãi, sử dụng giá gốc
        setState(() {
          int numberPirceXe = int.parse(priceXe);
          totalAmount = (rentalDays * numberPirceXe);
          originalTotalAmount = totalAmount;
        });
      }
    }
  }

  Future<void> _addBooking({
    required String numberPlate,
    required DateTime? pickupDateTime,
    required DateTime? returnDateTime,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    String email = widget.motorcycle['email'] ?? 'No email';

    if (user != null && user.email != email) {
      if (pickupDateTime != null && returnDateTime != null) {
        int numberOfRentalDay =
            returnDateTime.difference(pickupDateTime).inDays;

        if (numberOfRentalDay > 0) {
          Map<String, dynamic> response = await _addBookingService.addBooking(
            email: user.email!, // Use the current user's email
            numberPlate: numberPlate,
            bookingDate: pickupDateTime,
            returnDate: returnDateTime,
            numberOfRentalDay: numberOfRentalDay,
            totalAmount: originalTotalAmount,
          );

          String bookingId = response['id'];
          String fcmToken = await fcmService.getFcmTokenForOwner(email);
          String accountOwner = widget.motorcycle['email'] ?? 'No email';

          if (fcmToken.isNotEmpty) {
            await fcmService.sendPushNotification(
                fcmToken,
                'Yêu cầu đặt xe',
                'Xe máy của bạn đã được đặt!',
                accountOwner,
                'NotificationListScreen');

            await NotificationService().addNotification(
                title: 'Yêu cầu đặt xe',
                body: 'Xe máy của bạn đã được đặt!',
                email: accountOwner,
                bookingId: bookingId,
                bookingDate: pickupDateTime,
                returnDate: returnDateTime);
          } else {
            await NotificationService().addNotification(
                title: 'Yêu cầu đặt xe',
                body: 'Xe máy của bạn đã được đặt!',
                email: accountOwner,
                bookingId: bookingId,
                bookingDate: pickupDateTime,
                returnDate: returnDateTime);
          }
        } else {
          print('Return date must be after the pickup date!');
        }
      } else {
        print(
            'Incomplete information: Please check the pickup or return date!');
      }
    } else {
      // If the emails match, do not allow booking
      print('Booking cannot be added, email is not allowed.');
    }
  }

  Future<LatLng> getCoordinates(
      String streetName, String district, String city, String country) async {
    final address = '$streetName,$district, $city, $country';
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final latitude = double.tryParse(data[0]['lat']);
        final longitude = double.tryParse(data[0]['lon']);

        if (latitude != null && longitude != null) {
          print("Vị độ $longitude, Kinh độ $latitude");
          return LatLng(latitude, longitude);
        }
      }
    }
    throw Exception('Không thể tải tọa độ');
  }

  Future<void> _fetchCoordinates() async {
    var address = widget.motorcycle['address'] ?? {};
    String streetName = address['streetName'] ?? '';
    String district = address['district'] ?? '';
    String city = address['city'] ?? '';
    String country = address['country'] ?? '';

    try {
      LatLng coordinates =
          await getCoordinates(streetName, district, city, country);
      setState(() {
        _mapCoordinates = coordinates; // Đảm bảo tọa độ được cập nhật
      });
    } catch (e) {
      print('Lỗi khi lấy tọa độ: $e');
    }
  }

  void getUserData(String email) async {
    UserService userService = UserService();
    Map<String, dynamic>? data = await userService.getUserData(email);

    if (data != null) {
      setState(() {
        userData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var info = widget.motorcycle['informationMoto'] ?? {};
    var address = widget.motorcycle['address'] ?? {};
    String district = address['district'];
    String city = address['city'];
    String email = widget.motorcycle['email'] ?? 'Không có email';

    return Scaffold(
      appBar: DetailMotoAppBar(motorcycle: widget.motorcycle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Builder(
                        builder: (context) {
                          String imageUrl = (info['images'] != null &&
                                  info['images'].isNotEmpty)
                              ? info['images'][0]
                              : 'assets/images/xe1.jpg';
                          Uri? uri = Uri.tryParse(imageUrl);
                          if (uri != null && uri.isAbsolute) {
                            return Image.network(
                              imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Image.asset(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }
                        },
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Motorcycle Name (dynamic)
                            Text(
                              info['nameMoto'] ?? 'Motorcycle Name',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                // Kiểm tra nếu giá gốc và giá sau khuyến mãi giống nhau
                                if (info['price'] == priceIsDiscount)
                                  // Hiển thị giá gốc với màu đen
                                  Text(
                                    NumberFormat("#,###", "vi_VN")
                                        .format(info['price']),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors.black, // Màu đen cho giá gốc
                                    ),
                                  )
                                else ...[
                                  // Hiển thị giá gốc với dấu gạch ngang
                                  Text(
                                    NumberFormat("#,###", "vi_VN")
                                        .format(info['price']),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .black54, // Màu xám nhạt cho giá gốc
                                      decoration: TextDecoration
                                          .lineThrough, // Dấu gạch ngang
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Khoảng cách giữa giá gốc và giá giảm

                                  // Hiển thị giá đã áp dụng khuyến mãi
                                  Text(
                                    NumberFormat("#,###", "vi_VN")
                                        .format(priceIsDiscount),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .red, // Màu đỏ cho giá sau khuyến mãi
                                    ),
                                  ),
                                ],
                                const Text(
                                  ' đ/day',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.yellow), // Star icon for rating
                          const SizedBox(width: 2),
                          const Text(
                            '5.0', // Rating score
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            'assets/images/fast-delivery.png', // Delivery icon
                            width: 24,
                            height: 24,
                          ),
                          const Text(
                            '10 trip', // Number of trips
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Đặc điểm', // Features
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Motorcycle Features
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 237, 236)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Color Feature
                            Row(
                              children: [
                                const Icon(Icons.energy_savings_leaf_outlined,
                                    color: Color.fromARGB(
                                        255, 255, 173, 21)), // Color icon
                                const SizedBox(width: 8),
                                Text(
                                  "Phân khối: ${info['vehicleMass'] ?? "Unknown"} cc",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 8),
                            // Fuel consumption
                            Row(
                              children: [
                                Icon(Icons.local_gas_station,
                                    color: Color.fromARGB(
                                        255, 255, 173, 21)), // Fuel icon
                                SizedBox(width: 8),
                                Text(
                                  "Nhiên liệu: ${info['energy'] ?? "Unknown"}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Mô tả',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Description (dynamic)
                      Text(
                        info['description'] ?? 'No description available.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thời gian thuê xe',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          pickupDate: pickupDate,
                          returnDate: returnDate,
                          pickupTime: pickupTime,
                          returnTime: returnTime,
                          onDateSelected: (DateTime newPickupDate,
                              DateTime newReturnDate,
                              String newPickupTime,
                              String newReturnTime) {
                            setState(() {
                              // Cập nhật giá trị khi chọn ngày mới
                              pickupDate = newPickupDate;
                              returnDate = newReturnDate;
                              pickupTime = newPickupTime;
                              returnTime = newReturnTime;
                              _updateDateTimes(); // Cập nhật lại thời gian sau khi thay đổi
                              _calculateTotalAmount();
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/calendar.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$pickupTime, ${pickupDate.day}/${pickupDate.month}/${pickupDate.year} - $returnTime, ${returnDate.day}/${returnDate.month}/${returnDate.year}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vị trí xe',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${district}, ${city}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _mapCoordinates != null
                    ? LocationOfMotoScreen(
                        latitude: _mapCoordinates!.latitude,
                        longitude: _mapCoordinates!.longitude,
                      )
                    : const CircularProgressIndicator()
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: userData?['information']['avatar'] != null &&
                          userData?['information']['avatar'].isNotEmpty
                      ? NetworkImage(userData?['information']
                          ['avatar']) // Nếu có URL hợp lệ
                      : AssetImage('assets/images/xe1.jpg')
                          as ImageProvider, // Nếu không, dùng ảnh mặc định từ assets
                ),

                const SizedBox(width: 8),

                // User's name, Rating, and number of trips
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData?['information']['name'] ?? 'User Name',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '5.0', // Đánh giá (Có thể lấy từ dữ liệu nếu có)
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.directions_car, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '36 chuyến', // Số chuyến (Có thể lấy từ dữ liệu nếu có)
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: Text(
                "Email: $email", // Display email, or fallback if not available
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 16),
            const DetailMotoBodyEvaluate(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Tổng tiền: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat("#,###", "vi_VN").format(totalAmount),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        ' VNĐ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController discountController =
                              TextEditingController();
                          ApplyPromoService promoService = ApplyPromoService();

                          return AlertDialog(
                            title: const Text('Nhập Mã Giảm Giá'),
                            content: TextField(
                              controller: discountController,
                              decoration: const InputDecoration(
                                hintText: 'Nhập mã giảm giá của bạn',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  String promoCode =
                                      discountController.text.trim();

                                  try {
                                    // Kiểm tra xem mã giảm giá đã được áp dụng chưa
                                    if (promoCode == appliedPromoCode) {
                                      promoService.showSnackbar(
                                        context,
                                        'Mã giảm giá này đã được áp dụng!',
                                        isError: true,
                                      );
                                      Navigator.of(context).pop();
                                      return;
                                    }
                                    // Gọi service để xử lý áp dụng mã khuyến mãi
                                    await promoService.applyPromoHandler(
                                      context,
                                      promoCode,
                                      originalTotalAmount,
                                    );

                                    // Lấy lại tổng tiền sau khi áp dụng khuyến mãi
                                    Map<String, dynamic>? promoDetails =
                                        await promoService
                                            .fetchPromoDetails(promoCode);

                                    if (promoDetails != null) {
                                      int newTotal =
                                          await promoService.applyPromo(
                                        promoCode: promoCode,
                                        totalAmount: originalTotalAmount,
                                        promoDetails: promoDetails,
                                      );
                                      setState(() {
                                        totalAmount =
                                            newTotal; // Cập nhật tổng tiền
                                        appliedPromoCode =
                                            promoCode; // Lưu mã đã áp dụng
                                      });
                                    }

                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    promoService.showSnackbar(
                                      context,
                                      e.toString(),
                                      isError: true,
                                    );
                                  }
                                },
                                child: const Text('Áp Dụng'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Hủy'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Mã Giảm Giá',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _addBooking(
                    numberPlate: widget.motorcycle['numberPlate'],
                    pickupDateTime: pickupDateTime,
                    returnDateTime: returnDateTime,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 173, 21),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Thuê'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
