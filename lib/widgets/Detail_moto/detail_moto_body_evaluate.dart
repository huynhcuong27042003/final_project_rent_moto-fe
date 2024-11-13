import 'package:flutter/material.dart';

class DetailMotoBodyEvaluate extends StatelessWidget {
  const DetailMotoBodyEvaluate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Đánh giá',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/sh.png'),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
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
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/sh.png'),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
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
    );
  }
}
