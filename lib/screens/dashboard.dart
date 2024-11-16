import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:final_project_rent_moto_fe/screens/history_rent/my_trip_screen.dart';
import 'package:final_project_rent_moto_fe/screens/home/rent_home/rent_home_screen.dart';
import 'package:final_project_rent_moto_fe/screens/users/user_infor_screen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // Theo dõi mục được chọn

  final List<Widget> _screens = [
    const RentHomeScreen(), // Trang Home
    const MyTripScreen(),
    const UserInforScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật trang hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset:
          true, // Cho phép giao diện thay đổi kích thước khi mở bàn phím
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
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
