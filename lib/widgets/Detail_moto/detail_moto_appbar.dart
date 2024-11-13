import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/screens/home/rent_home/rent_home_screen.dart';

class DetailMotoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailMotoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 173, 21),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          const Expanded(
            child: Center(
              child: Text(
                '70D1-75491',
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
