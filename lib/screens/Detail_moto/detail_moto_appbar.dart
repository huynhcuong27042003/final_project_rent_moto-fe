import 'package:flutter/material.dart';

class DetailMotoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> motorcycle;

  const DetailMotoAppBar({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context) {
    var info = motorcycle['informationMoto'] ?? {};

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 173, 21),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () {},
          // ),
          Expanded(
            child: Center(
              child: Text(
                "${motorcycle['numberPlate'] ?? 'Unknown'}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              // Handle the heart icon press action
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
