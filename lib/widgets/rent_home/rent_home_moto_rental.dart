import 'package:flutter/material.dart';

class RentHomeMotoRental extends StatefulWidget {
  const RentHomeMotoRental({super.key});

  @override
  State<RentHomeMotoRental> createState() => _RentHomeMotoRentalState();
}

class _RentHomeMotoRentalState extends State<RentHomeMotoRental> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/moto_rental.jpg', // Replace with your image path
                  fit: BoxFit.cover,
                  height: 180,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          const Positioned(
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                "Bạn có muốn đăng xe lên cho thuê?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                // Add your onPressed functionality here
              },
              child: const Text(
                "Đăng xe lên cho thuê",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
