import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/signup/signup_enter_password/signup_enter_password_body.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/signup/signup_enter_password/signup_enter_password_header.dart';

class SignupEnterPasswordScreen extends StatefulWidget {
  const SignupEnterPasswordScreen({super.key});

  @override
  State<SignupEnterPasswordScreen> createState() =>
      _SignupEnterPasswordScreenState();
}

class _SignupEnterPasswordScreenState extends State<SignupEnterPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Step 3',
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
            child: SignupEnterPasswordHeader(),
          ),
          SignupEnterPasswordBody(),
        ],
      ),
    );
  }
}
