import 'package:flutter/material.dart';

class DetailMotoBodyLocation extends StatefulWidget {
  const DetailMotoBodyLocation({super.key});

  @override
  _DetailMotoBodyLocationState createState() => _DetailMotoBodyLocationState();
}

class _DetailMotoBodyLocationState extends State<DetailMotoBodyLocation> {
  String _selectedPickupOption = 'self_pickup';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thời gian thuê xe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
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
        RadioListTile(
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
        RadioListTile(
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
      ],
    );
  }
}
