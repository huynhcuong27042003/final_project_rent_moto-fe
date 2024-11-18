import 'package:final_project_rent_moto_fe/widgets/modals/calendar_rental.dart';
import 'package:flutter/material.dart';

class DetailMotoBodyLocation extends StatefulWidget {
  const DetailMotoBodyLocation({Key? key}) : super(key: key);

  @override
  _DetailMotoBodyLocationState createState() => _DetailMotoBodyLocationState();
}

class _DetailMotoBodyLocationState extends State<DetailMotoBodyLocation> {
  String _selectedPickupOption = 'self_pickup'; // Default pickup option

  late DateTime pickupDate; // Khai báo ngày nhận
  late DateTime returnDate; // Khai báo ngày trả
  String pickupTime = "21:00";
  String returnTime = "22:00";

  DateTime? pickupDateTime;
  DateTime? returnDateTime;

  @override
  void initState() {
    super.initState();
    pickupDate = DateTime.now();
    returnDate = pickupDate.add(const Duration(days: 1));
    _updateDateTimes(); // Cập nhật giá trị pickupDateTime và returnDateTime ngay khi khởi tạo
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

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
