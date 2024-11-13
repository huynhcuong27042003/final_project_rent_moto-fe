
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_appbar.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_information.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_body_location.dart';
import 'package:final_project_rent_moto_fe/screens/Detail_moto/detail_moto_bottomnav.dart';
import 'package:flutter/material.dart';

class DetailMotoScreen extends StatelessWidget {
  const DetailMotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DetailMotoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DetailMotoBodyCharacteristic(motorcycle: {},),
            SizedBox(height: 16),
            DetailMotoBodyLocation(),
            SizedBox(height: 16),
            DetailMotoBodyEvaluate(),
          ],
        ),
      ),
      bottomNavigationBar: const DetailMotoBottomNav(),
    );
  }
}
