import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_rent_moto_fe/services/bookingMoto/addbookingService.dart';
import 'package:final_project_rent_moto_fe/services/promo/apply_promo_service.dart';
import 'package:final_project_rent_moto_fe/widgets/detail_moto/detail_moto.dart';
import 'package:final_project_rent_moto_fe/widgets/detail_moto/detail_moto_appbar.dart';
import 'package:final_project_rent_moto_fe/widgets/modals/calendar_rental.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailMotoScreen extends StatefulWidget {
  final Map<String, dynamic> motorcycle; // Thêm một tham số để nhận dữ liệu

  const DetailMotoScreen({super.key, required this.motorcycle});
  @override
  State<DetailMotoScreen> createState() => _DetailMotoScreenState();
}

class _DetailMotoScreenState extends State<DetailMotoScreen> {
  // Nhận dữ liệu từ constructor
  String _selectedPickupOption = 'self_pickup'; // Default pickup option

  late DateTime pickupDate; // Khai báo ngày nhận
  late DateTime returnDate; // Khai báo ngày trả
  String pickupTime = "21:00";
  String returnTime = "22:00";
  int totalAmount = 0;
  int originalTotalAmount = 0;
  DateTime? pickupDateTime;
  DateTime? returnDateTime;
  final _addBookingService = AddBookingservice();
  String? appliedPromoCode;
  void initState() {
    super.initState();
    pickupDate = DateTime.now();
    returnDate = pickupDate.add(const Duration(days: 1));
    _updateDateTimes(); // Cập nhật giá trị pickupDateTime và returnDateTime ngay khi khởi tạo
    _calculateTotalAmount();
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
  void _calculateTotalAmount() {
    if (pickupDateTime != null && returnDateTime != null) {
      // Tính số ngày thuê
      int rentalDays = returnDateTime!.difference(pickupDateTime!).inDays;

      // Lấy giá thuê từ thông tin xe
      var info = widget.motorcycle['informationMoto'] ?? {};
      String priceXe = info['price'].toString();
      String priceXeTemp = priceXe;
      int numberPirceXe = int.parse(priceXeTemp);
      print(numberPirceXe);

      // Tính tổng tiền
      setState(() {
        totalAmount = (rentalDays * numberPirceXe);
        originalTotalAmount = totalAmount;
      });
    }
  }

  Future<void> _addBooking({
    required String numberPlate,
    required DateTime? pickupDateTime,
    required DateTime? returnDateTime,
  }) async {
    // Lấy thông tin người dùng đang đăng nhập
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && pickupDateTime != null && returnDateTime != null) {
      String email = user.email!;
      String bookingDate =
          DateFormat('yyyy-MM-dd HH:mm').format(pickupDateTime);
      String returnDate = DateFormat('yyyy-MM-dd HH:mm').format(returnDateTime);

      int numberOfRentalDay = returnDateTime.difference(pickupDateTime).inDays;

      if (numberOfRentalDay > 0) {
        // Gọi service để thêm booking
        await _addBookingService.addBooking(
          email: email,
          numberPlate: numberPlate,
          bookingDate: bookingDate,
          returnDate: returnDate,
          numberOfRentalDay: numberOfRentalDay,
        );

        print(
            'Booking thành công: $email, $numberPlate, $bookingDate, $returnDate, $numberOfRentalDay ngày');
      } else {
        print('Ngày trả xe phải sau ngày thuê!');
      }
    } else {
      print('Thông tin không đầy đủ: Vui lòng kiểm tra email hoặc ngày thuê!');
    }
  }

  @override
  Widget build(BuildContext context) {
    var info = widget.motorcycle['informationMoto'] ?? {};
    return Scaffold(
      appBar: DetailMotoAppBar(motorcycle: widget.motorcycle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Truyền dữ liệu vào DetailMotoBodyCharacteristic
            Column(
              children: [
                // Image section with dynamic image loading
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      info['images'] != null && info['images'].isNotEmpty
                          ? info['images']
                              [0] // Use the first image if available
                          : '', // If no image, use an empty string
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                                const Icon(Icons.attach_money,
                                    color: Colors.green),
                                // Dynamic price
                                Text(
                                  '${info['price'] ?? "0"} / day',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
                                const Icon(Icons.color_lens,
                                    color: Color.fromARGB(
                                        255, 255, 173, 21)), // Color icon
                                const SizedBox(width: 8),
                                Text(
                                  "Vehicle Mass: ${info['vehicleMass'] ?? "Unknown"} cc",
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
                                  "Energy: ${info['energy'] ?? "Unknown"}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
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
                  'Rental Duration',
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
                  'Pickup or Delivery Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RadioListTile(
                  value: 'self_pickup',
                  groupValue: _selectedPickupOption,
                  activeColor: Colors.green,
                  title: const Text('I will pick up the vehicle myself'),
                  onChanged: (value) {
                    setState(() {
                      _selectedPickupOption = value!;
                    });
                  },
                ),
                RadioListTile(
                  value: 'delivery',
                  groupValue: _selectedPickupOption,
                  activeColor: Colors.green,
                  title: const Text('I want the vehicle delivered to me'),
                  onChanged: (value) {
                    setState(() {
                      _selectedPickupOption = value!;
                    });
                  },
                ),
              ],
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
                  Text(
                    'Tổng tiền: $totalAmount',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
