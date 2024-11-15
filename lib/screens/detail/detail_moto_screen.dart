import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_appbar.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_body_location.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_bottomnav.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_information.dart';
import 'package:flutter/material.dart';

class DetailMotoScreen extends StatelessWidget {
  final Map<String, dynamic> motorcycle; // Thêm một tham số để nhận dữ liệu

  const DetailMotoScreen(
      {super.key, required this.motorcycle}); // Nhận dữ liệu từ constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailMotoAppBar(motorcycle: motorcycle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Truyền dữ liệu vào DetailMotoBodyCharacteristic
            DetailMotoBodyCharacteristic(motorcycle: motorcycle),
            const SizedBox(height: 16),
            const DetailMotoBodyLocation(),
            const SizedBox(height: 16),
            const DetailMotoBodyEvaluate(),
          ],
        ),
      ),
      bottomNavigationBar: const DetailMotoBottomNav(),
    );
  }
}
