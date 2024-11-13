import 'package:final_project_rent_moto_fe/widgets/Detail_moto/Detail_moto_appbar.dart';
import 'package:final_project_rent_moto_fe/widgets/Detail_moto/detail_moto_body_Evaluate.dart';
import 'package:final_project_rent_moto_fe/widgets/Detail_moto/detail_moto_body_characteristic.dart';
import 'package:final_project_rent_moto_fe/widgets/Detail_moto/detail_moto_body_location.dart';
import 'package:final_project_rent_moto_fe/widgets/Detail_moto/detail_moto_bottomnav.dart';
import 'package:flutter/material.dart';

class DetailMotoScreen extends StatelessWidget {
  const DetailMotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DetailMotoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DetailMotoBodyCharacteristic(),
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
