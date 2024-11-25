import 'package:final_project_rent_moto_fe/screens/map/location_of-moto.dart';
import 'package:final_project_rent_moto_fe/services/bookingMoto/addbookingService.dart';
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
  String _selectedPickupOption = 'self_pickup'; // Default pickup option

  late DateTime pickupDate; // Khai báo ngày nhận
  late DateTime returnDate; // Khai báo ngày trả
  String pickupTime = "21:00";
  String returnTime = "22:00";
  int totalAmount = 0;
  DateTime? pickupDateTime;
  DateTime? returnDateTime;
  final _addBookingService = AddBookingService();
  LatLng? _mapCoordinates;
  @override
  void initState() {
    super.initState();
    pickupDate = DateTime.now();
    returnDate = pickupDate.add(const Duration(days: 1));
    _updateDateTimes(); // Cập nhật giá trị pickupDateTime và returnDateTime ngay khi khởi tạo
    _calculateTotalAmount();
    _fetchCoordinates();
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

      // Tính tổng tiền
      setState(() {
        totalAmount = (rentalDays * numberPirceXe);
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

      int numberOfRentalDay = returnDateTime.difference(pickupDateTime).inDays;

      if (numberOfRentalDay > 0) {
        // Gọi service để thêm booking
        await _addBookingService.addBooking(
          email: email,
          numberPlate: numberPlate,
          bookingDate: pickupDateTime,
          returnDate: returnDateTime,
          numberOfRentalDay: numberOfRentalDay,
        );
      } else {
        print('Ngày trả xe phải sau ngày thuê!');
      }
    } else {
      print('Thông tin không đầy đủ: Vui lòng kiểm tra email hoặc ngày thuê!');
    }
  }

  Future<LatLng> getCoordinates(
      String streetName, String district, String city, String country) async {
    final address = '$district, $city, $country';
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
      // Xử lý lỗi nếu không lấy được tọa độ
    }
  }

  @override
  Widget build(BuildContext context) {
    var info = widget.motorcycle['informationMoto'] ?? {};
    var address = widget.motorcycle['address'] ?? {};
    String district = address['district'];
    String city = address['city'];

    return Scaffold(
      appBar: DetailMotoAppBar(motorcycle: widget.motorcycle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                Text(
                                  NumberFormat("#,###", "vi_VN")
                                      .format(info['price']),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' đ/day',
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
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Handle discount code here if needed
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
                      returnDateTime: returnDateTime);
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
