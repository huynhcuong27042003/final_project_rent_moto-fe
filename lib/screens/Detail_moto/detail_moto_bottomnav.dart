import 'package:flutter/material.dart';

class DetailMotoBottomNav extends StatelessWidget {
  const DetailMotoBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                const Text(
                  'Tổng tiền: 10\$',
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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Thuê Xe'),
                    content: const Text('Bạn đã thuê xe thành công!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
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
    );
  }
}
