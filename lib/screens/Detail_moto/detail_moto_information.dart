import 'package:flutter/material.dart';

class DetailMotoBodyCharacteristic extends StatelessWidget {
  final Map<String, dynamic> motorcycle;

  const DetailMotoBodyCharacteristic({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/fast-delivery.png',
                    width: 24,
                    height: 24,
                  ),
                  const Text(
                    '10 trip',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 236, 237, 236).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            ],
          ),
        ),
      ],
    );
  }
}
