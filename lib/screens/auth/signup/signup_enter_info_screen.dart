import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/signup/signup_enter_info/signup_enter_infor_body.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/signup/signup_enter_info/signup_enter_infor_header.dart';

class SignupEnterInfoScreen extends StatefulWidget {
  const SignupEnterInfoScreen({super.key});

  @override
  State<SignupEnterInfoScreen> createState() => _SignupEnterInfoScreenState();
}

class _SignupEnterInfoScreenState extends State<SignupEnterInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Step 4',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 30),
        ),
        backgroundColor: const Color(0xFFFFAD15),
      ),
      body: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: SignupEnterInforHeader(),
          ),
          SignupEnterInforBody(),
        ],
      ),
    );
  }
}
