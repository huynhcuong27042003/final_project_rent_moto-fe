import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:final_project_rent_moto_fe/screens/history_rent/history_trip_screen.dart';
import 'package:final_project_rent_moto_fe/screens/history_rent/my_trip_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/widgets/rent_home/rent_home_background.dart';
import 'package:final_project_rent_moto_fe/widgets/rent_home/rent_home_infor_motos.dart';
import 'package:final_project_rent_moto_fe/widgets/rent_home/rent_home_moto_rental.dart';
import 'package:final_project_rent_moto_fe/widgets/rent_home/rent_home_promo.dart';
import 'package:final_project_rent_moto_fe/widgets/rent_home/rent_home_search_motos.dart';

class RentHomeScreen extends StatefulWidget {
  const RentHomeScreen({super.key});

  @override
  State<RentHomeScreen> createState() => _RentHomeScreenState();
}

class _RentHomeScreenState extends State<RentHomeScreen> {
  int _selectedIndex = 0; // Theo dõi mục được chọn

  final List<Widget> _screens = [
    const HomeContentScreen(), // Trang Home
    const MyTripScreen(),
    // const HistoryTripScreen(), // Trang MyTrip
    const ProfileScreen(), // Trang Profile (bạn cần tự tạo trang này)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật trang hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: const Color(0xFFF49C21),
        color: const Color(0xFFF49C21),
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.motorcycle_outlined, size: 30, color: Colors.white),
          Icon(Icons.account_box_sharp, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

// Trang nội dung chính của màn hình Home
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          const RentHomeBackground(),
          const RentHomeSearchMotos(),
          Container(
            margin: const EdgeInsets.only(top: 400, left: 20),
            child: const Column(
              children: [
                RentHomePromo(),
                RentHomeInforMotos(),
                RentHomeMotoRental(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Trang Profile (Bạn cần tạo trang Profile phù hợp với ứng dụng của bạn)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Profile Page"),
      ),
    );
  }
}
