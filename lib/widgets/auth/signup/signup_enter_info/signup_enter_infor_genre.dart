// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SignupEnterInforGenre extends StatefulWidget {
  const SignupEnterInforGenre({super.key});

  @override
  _SignupEnterInforGenreState createState() => _SignupEnterInforGenreState();
}

class _SignupEnterInforGenreState extends State<SignupEnterInforGenre> {
  String selectedGenre = 'Male';

  void _selectGenre(String genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA500).withOpacity(0.5),
            offset: const Offset(-2, -2),
            blurRadius: 15,
          ),
          BoxShadow(
            color: const Color(0xFFDA70D6).withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selectedGenre,
              style: TextStyle(
                color: selectedGenre == 'Select Genre'
                    ? Colors.grey
                    : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: _selectGenre,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                ),
                const PopupMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
