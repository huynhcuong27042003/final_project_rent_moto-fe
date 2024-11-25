import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_rent_moto_fe/services/bookingMoto/addbookingService.dart';
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
  DateTime? pickupDateTime;
  DateTime? returnDateTime;
  final _addBookingService = AddBookingservice();
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

  Future<int> applyPromo({
    required String promoCode,
    required int totalAmount,
    required Map<String, dynamic> promoDetails,
  }) async {
    // Kiểm tra mã khuyến mãi có hợp lệ không
    if (promoCode != promoDetails['code']) {
      throw Exception('Mã khuyến mãi không hợp lệ');
    }

    // Kiểm tra ngày khuyến mãi
    DateTime startDate = DateTime.parse(promoDetails['startDate']);
    DateTime endDate = DateTime.parse(promoDetails['endDate']);
    DateTime today = DateTime.now();

    if (today.isBefore(startDate) || today.isAfter(endDate)) {
      throw Exception('Khuyến mãi này đã hết hạn hoặc chưa được kích hoạt');
    }

    // Kiểm tra trạng thái ẩn/hiển của khuyến mãi
    if (promoDetails['isHide'] == true) {
      throw Exception('Khuyến mãi này hiện không khả dụng');
    }

    // Tính tổng tiền sau giảm giá
    int discount = promoDetails['discount']; // Lấy tỷ lệ giảm giá
    int discountedAmount = (totalAmount * (100 - discount) ~/ 100);

    return discountedAmount;
  }

  Future<Map<String, dynamic>?> fetchPromoDetails(String promoCode) async {
    try {
      // Truy cập collection "promotions" trên Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('promotions')
          .where('code', isEqualTo: promoCode)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Lấy document đầu tiên
        return snapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        // Không tìm thấy mã khuyến mãi
        return null;
      }
    } catch (e) {
      print('Lỗi khi lấy mã khuyến mãi: $e');
      return null;
    }
  }

  void showSnackbar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> applyPromoHandler(
      BuildContext context, String promoCode, int totalAmount) async {
    try {
      // Gọi hàm `fetchPromoDetails`
      Map<String, dynamic>? promoDetails = await fetchPromoDetails(promoCode);

      if (promoDetails == null) {
        showSnackbar(context, 'Mã khuyến mãi không tồn tại', isError: true);
        return;
      }

      // Gọi hàm `applyPromo`
      int discountedAmount = await applyPromo(
        promoCode: promoCode,
        totalAmount: totalAmount,
        promoDetails: promoDetails,
      );

      showSnackbar(
        context,
        'Áp dụng thành công! Tổng tiền sau khi giảm: $discountedAmount',
        isError: false,
      );
    } catch (e) {
      // Hiển thị thông báo lỗi
      showSnackbar(context, e.toString(), isError: true);
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
                    'Tổng tiền: ${totalAmount}',
                    style: TextStyle(
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
                                  try {
                                    String promoCode =
                                        discountController.text.trim();

                                    // Lấy thông tin khuyến mãi từ Firebase
                                    Map<String, dynamic>? promoDetails =
                                        await fetchPromoDetails(promoCode);

                                    if (promoDetails == null) {
                                      throw Exception(
                                          'Mã khuyến mãi không tồn tại');
                                    }

                                    // Kiểm tra và áp dụng khuyến mãi
                                    int newTotal = await applyPromo(
                                      promoCode: promoCode,
                                      totalAmount: totalAmount,
                                      promoDetails: promoDetails,
                                    );

                                    setState(() {
                                      totalAmount = newTotal;
                                    });

                                    // Hiển thị thông báo thành công
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Giảm giá thành công! Tổng tiền: $newTotal',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );

                                    // Đóng hộp thoại (nếu cần)
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    // Hiển thị thông báo lỗi
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
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
