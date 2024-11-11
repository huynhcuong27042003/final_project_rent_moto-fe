import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/screens/history_rent/my_trip_screen.dart';

class HistoryTripScreen extends StatefulWidget {
  const HistoryTripScreen({super.key});

  @override
  State<HistoryTripScreen> createState() => _HistoryTripScreenState();
}

class _HistoryTripScreenState extends State<HistoryTripScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 244, 156, 33), // Màu nền AppBar
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa
          children: [
            Spacer(), // Cách bên trái
            Text(
              'Lịch Sử Chuyến Đi', // Tiêu đề cho AppBar
              style: TextStyle(color: Colors.black),
            ),
            Spacer(), // Cách bên phải
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MyTripScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: const Center(
        child: Text('Nội dung lịch sử chuyến đi sẽ hiển thị ở đây.'),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
