import 'package:flutter/material.dart';

class SignupEnterInforHeader extends StatefulWidget {
  const SignupEnterInforHeader({super.key});

  @override
  State<SignupEnterInforHeader> createState() => _SignupEnterInforHeaderState();
}

class _SignupEnterInforHeaderState extends State<SignupEnterInforHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -650,
          left: -200,
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
          right: 20, // Điều chỉnh vị trí của văn bản
          child: Text(
            'Field information to continue!',
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
