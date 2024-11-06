import 'package:flutter/material.dart';

class LoginHeader extends StatefulWidget {
  const LoginHeader({super.key});

  @override
  State<LoginHeader> createState() => _LoginHeaderState();
}

class _LoginHeaderState extends State<LoginHeader> {
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
            'Welcome',
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
            'Back!',
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
            'Please sign in to continue!',
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
