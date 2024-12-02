// ignore_for_file: use_key_in_widget_constructors
import 'package:final_project_rent_moto_fe/screens/booking/booking_details_screen.dart';
import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:final_project_rent_moto_fe/services/notification/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationListByUser extends StatelessWidget {
  final String email;

  const NotificationListByUser({required this.email});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF49C21),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: NotificationService().getNotificationsByEmail(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //   return Center(child: Text('No notifications found.'));
          // }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return FutureBuilder(
              future:
                  Future.delayed(const Duration(seconds: 2)), // Độ trễ 2 giây
              builder: (context, snapshotFuture) {
                if (snapshotFuture.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent), // Tùy chỉnh màu sắc của vòng tròn
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Bạn không có yêu cầu đặt xe mới',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                }
              },
            );
          }

          List<Map<String, dynamic>> notifications =
              snapshot.data!.where((notification) {
            DateTime returnDate = DateTime.parse(notification['returnDate']);
            return returnDate.isAfter(DateTime.now());
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> notification = notifications[index];

              // Extract notification fields (if present)
              String title = notification['title'] ?? 'No Title';
              String body = notification['body'] ?? 'No body';
              String bookingId = notification['bookingId'];
              String id =
                  notification['id']; // This is the document ID from Firestore

              // Parse and format dates
              DateTime bookingDate =
                  DateTime.parse(notification['bookingDate']);
              DateTime returnDate = DateTime.parse(notification['returnDate']);

              String formattedBookingDate =
                  DateFormat('yyyy-MM-dd – HH:mm').format(bookingDate);
              String formattedReturnDate =
                  DateFormat('yyyy-MM-dd – HH:mm').format(returnDate);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        body,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ngày đặt: $formattedBookingDate',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Text(
                        'Ngày trả: $formattedReturnDate',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Điều hướng tới màn hình BookingDetailsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(
                          bookingId: bookingId,
                          notificationId: id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
