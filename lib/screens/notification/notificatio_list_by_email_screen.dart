import 'package:final_project_rent_moto_fe/services/bookingMoto/get_booking_service.dart';
import 'package:final_project_rent_moto_fe/services/bookingMoto/update_is_hide_booking_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificatioListByEmailScreen extends StatefulWidget {
  final String email;

  const NotificatioListByEmailScreen({super.key, required this.email});

  @override
  _NotificatioListByEmailScreenState createState() =>
      _NotificatioListByEmailScreenState();
}

class _NotificatioListByEmailScreenState
    extends State<NotificatioListByEmailScreen> {
  late Future<Map<String, dynamic>> _bookings;
  final UpdateIsHideBookingService updateIsHideBookingService =
      UpdateIsHideBookingService();

  @override
  void initState() {
    super.initState();
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser?.email ?? '';
    _bookings = GetBookingService().getBookingsByEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bookings,
        builder: (context, snapshot) {
          // Handle connection states
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!['bookings'] == null) {
            return const Center(
                child: Text('Bạn không có yêu cầu đặt xe mới',
                    style: TextStyle(fontSize: 16, color: Colors.red)));
          } else {
            var bookings = snapshot.data!['bookings'] as List;

            // Lọc các booking đã hết hạn và cập nhật trạng thái isHide
            var filteredBookings = bookings.where((booking) {
              DateTime acceptTime = booking['acceptTime'];
              DateTime vietnamAcceptTime =
                  acceptTime.add(const Duration(hours: 7));
              DateTime vietnamCurrentTime =
                  DateTime.now().add(const Duration(hours: 7));
              Duration timeDifference =
                  vietnamCurrentTime.difference(vietnamAcceptTime);

              // Chỉ gọi update nếu booking đã hết hạn và chưa được ẩn
              if (timeDifference.inHours >= 5 && booking['isHide'] == false) {
                updateIsHideBookingService.hideBooking(booking['id']);
              }

              // Lọc những booking hợp lệ và chưa bị ẩn
              return timeDifference.inHours < 5 && booking['isHide'] == false;
            }).toList();

            if (filteredBookings.isEmpty) {
              return const Center(
                  child: Text('Yêu cầu đặt xe của bạn chưa được chấp nhận',
                      style: TextStyle(fontSize: 16, color: Colors.red)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                var booking = filteredBookings[index];

                DateTime bookingDate = booking['bookingDate'];
                DateTime returnDate = booking['returnDate'];
                DateTime acceptTime = booking['acceptTime'];

                DateTime vietnamBookingDate =
                    bookingDate.add(const Duration(hours: 7));
                DateTime vietnamReturnDate =
                    returnDate.add(const Duration(hours: 7));
                DateTime vietnamAcceptTime =
                    acceptTime.add(const Duration(hours: 7));

                String formattedBookingDate =
                    DateFormat('yyyy-MM-dd – HH:mm').format(vietnamBookingDate);
                String formattedReturnDate =
                    DateFormat('yyyy-MM-dd – HH:mm').format(vietnamReturnDate);

                DateTime vietnamCurrentTime = DateTime.now().add(const Duration(
                    hours: 7)); // Thời gian hiện tại ở Việt Nam (UTC+7)
                Duration timeDifference = vietnamCurrentTime.difference(
                    vietnamAcceptTime); // So sánh sự khác biệt với thời gian chấp nhận
                bool isExpired = timeDifference.inHours >=
                    3; // Kiểm tra xem đã quá 3 giờ chưa

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Biển số xe: ${booking['numberPlate']}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        Text(
                          'Ngày đặt xe: $formattedBookingDate',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        Text(
                          'Ngày trả: $formattedReturnDate',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        Text(
                          'Số ngày thuê: ${booking['numberOfRentalDay']}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        Text(
                          booking['isAccept']
                              ? "Đã được chấp nhận"
                              : "Chưa được chấp nhận",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        // Kiểm tra trạng thái hết hạn hoặc hợp lệ
                        isExpired
                            ? Text(
                                'Yêu cầu đặt xe đã hết hạn',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Xử lý thanh toán ở đây
                                    print('Thanh toán cho booking');
                                  },
                                  child: const Text('Thanh toán'),
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
