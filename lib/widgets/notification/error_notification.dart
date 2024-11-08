import 'package:flutter/material.dart';

class ErrorNotification extends StatelessWidget {
  final String text;
  const ErrorNotification({super.key, required this.text});

  SnackBar buildSnackBar() {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(); // Không cần hiển thị gì cả
  }
}
