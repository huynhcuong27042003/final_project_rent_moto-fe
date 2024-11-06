import 'package:flutter/material.dart';

class SignupEnterPasswordHeader extends StatefulWidget {
  const SignupEnterPasswordHeader({super.key});

  @override
  State<SignupEnterPasswordHeader> createState() =>
      _SignupEnterPasswordHeaderState();
}

class _SignupEnterPasswordHeaderState extends State<SignupEnterPasswordHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -650,
          right: -200,
          child: Container(
            width: 900,
            height: 800,
            decoration: const BoxDecoration(
              color: Color(0xFFFFAD15),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 30,
          child: Text(
            'Create',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
        ),
        const Positioned(
          top: 30, // Điều chỉnh vị trí của văn bản
          right: 90, // Điều chỉnh vị trí của văn bản
          child: Text(
            'Account!',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white, // Màu sắc của văn bản
            ),
          ),
        ),
        const Positioned(
          top: 100, // Điều chỉnh vị trí của văn bản
          left: 20, // Điều chỉnh vị trí của văn bản
          child: Text(
            'Enter password to continue!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white, // Màu sắc của văn bản
            ),
          ),
        ),
      ],
    );
  }
}
