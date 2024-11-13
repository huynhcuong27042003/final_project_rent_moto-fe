import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/screens/history_rent/history_trip_screen.dart';

// Import trang HistoryTripScreen

class MyTripScreen extends StatefulWidget {
  const MyTripScreen({super.key});

  @override
  State<MyTripScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyTripScreen>
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
        backgroundColor: const Color(0xFFF49C21), // Màu nền AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 100), // khoảng cách trái bằng 0
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Chuyến xe của tôi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.history, color: Colors.black),
              onPressed: () {
                // Chuyển hướng đến trang HistoryTripScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryTripScreen()),
                );
              },
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Khung xe 1
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Hình ảnh xe
                    SizedBox(
                      width: 100, // Chiều rộng của hình ảnh
                      child: Image.asset(
                        'assets/images/sh.png', // Đường dẫn ảnh xe 1
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                        width: 16), // Khoảng cách giữa hình và nội dung
                    // Thông tin xe
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FU', // Tên xe 1
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Biển số: 70D1-75491'), // Biển số xe 1
                        ],
                      ),
                    ),
                    // Nút hủy chuyến
                    SizedBox(
                      width: 100, // Chiều rộng của nút
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý hủy chuyến tại đây
                        },
                        child: const Text('Hủy'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Khung xe 2
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Hình ảnh xe
                    SizedBox(
                      width: 100, // Chiều rộng của hình ảnh
                      child: Image.asset(
                        'assets/images/sh.png', // Đường dẫn ảnh xe 2 (có thể thay đổi thành ảnh khác)
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                        width: 16), // Khoảng cách giữa hình và nội dung
                    // Thông tin xe
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sh Mode', // Tên xe 2
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Biển số: 70D1-75491'), // Biển số xe 2
                        ],
                      ),
                    ),
                    // Nút hủy chuyến
                    SizedBox(
                      width: 100, // Chiều rộng của nút
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý hủy chuyến tại đây
                        },
                        child: const Text('Hủy'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
