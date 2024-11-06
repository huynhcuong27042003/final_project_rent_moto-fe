import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/screens/home/rent_home/rent_home_screen.dart';

class DetailMotoScreen extends StatefulWidget {
  const DetailMotoScreen({super.key});

  @override
  State<DetailMotoScreen> createState() => _DetailMotoScreenState();
}

class _DetailMotoScreenState extends State<DetailMotoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Khởi tạo biến lưu giá trị của tùy chọn được chọn
  String _selectedPickupOption = 'self_pickup';

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
        backgroundColor: const Color.fromARGB(255, 255, 173, 21),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RentHomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            const Expanded(
              child: Center(
                child: Text(
                  '70D1-75491',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                // Xử lý hành động khi nhấn trái tim
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                margin: const EdgeInsets.all(0.0),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "assets/images/moto.jpg",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'FUTURE 2021',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.attach_money, color: Colors.green),
                              Text(
                                '10\$ \\ 1 ngày',
                                style: TextStyle(
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
                        const Icon(Icons.star, color: Colors.yellow),
                        const SizedBox(width: 2),
                        const Text(
                          '5.0',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/fast-delivery.png',
                          width: 24,
                          height: 24,
                        ),
                        const Text(
                          '10 trip',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thời gian thuê xe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
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
                              '23h00, 1/1 - 23h00, 3/1',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Địa điểm giao nhận xe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: RadioListTile(
                          value: 'self_pickup',
                          groupValue: _selectedPickupOption,
                          activeColor: Colors.green,
                          title: const Text('Tôi tự đến lấy'),
                          onChanged: (value) {
                            setState(() {
                              _selectedPickupOption = value!;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: RadioListTile(
                          value: 'delivery',
                          groupValue: _selectedPickupOption,
                          activeColor: Colors.green,
                          title: const Text('Tôi muốn được giao xe tận nơi'),
                          onChanged: (value) {
                            setState(() {
                              _selectedPickupOption = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Đặc điểm',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 237, 236)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.color_lens,
                                    color: Color.fromARGB(255, 255, 173, 21)),
                                SizedBox(width: 8),
                                Text(
                                  'Màu sắc: Cam - Đen',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.motorcycle,
                                    color: Color.fromARGB(255, 255, 173, 21)),
                                SizedBox(width: 8),
                                Text(
                                  'Phân khối: 110cc',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.local_gas_station,
                                    color: Color.fromARGB(255, 255, 173, 21)),
                                SizedBox(width: 8),
                                Text(
                                  'Tiêu hao nhiên liệu: 3L/100km',
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
                      const Text(
                        'Future FI là một mẫu xe máy rất phổ biến, tiết kiệm nhiên liệu và phù hợp cho việc di chuyển hàng ngày. Xe có thiết kế hiện đại và nhiều tính năng tiện ích.',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Đánh giá',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/sh.png'),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('CKA'),
                          ],
                        ),
                        subtitle: Text(
                          'Xe chạy rất tốt, tiết kiệm nhiên liệu!',
                        ),
                      ),
                      const Divider(),
                      const ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/sh.png'),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text('CKA'),
                          ],
                        ),
                        subtitle: Text(
                          'Xe chạy rất tốt, tiết kiệm nhiên liệu!',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  const Text(
                    'Tổng tiền: 10\$',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Hiển thị hộp thoại để nhập mã giảm giá
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
                                  // Xử lý mã giảm giá ở đây nếu cần
                                  // String discountCode = discountController.text;
                                  // Gọi API hoặc xử lý mã giảm giá
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
                  // Xử lý hành động khi nhấn nút Thuê
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
      ),
    );
  }
}
