import 'package:final_project_rent_moto_fe/screens/auth/signup/signup_change_avatar_screen.dart';
import 'package:final_project_rent_moto_fe/services/auth/signup_service.dart';
import 'package:final_project_rent_moto_fe/widgets/notification/success_notification.dart';

import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/auth/validator_service.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/button_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/signup/signup_enter_info/signup_enter_infor_date_text.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_username_auth.dart';

class SignupEnterInforBody extends StatefulWidget {
  final String email;
  const SignupEnterInforBody({super.key, required this.email});

  @override
  State<SignupEnterInforBody> createState() => _SignupEnterInforBodyState();
}

class _SignupEnterInforBodyState extends State<SignupEnterInforBody> {
  final _controllerFullName = TextEditingController();
  final _controllerLICNumber = TextEditingController();
  final _controllerPhoneNumber = TextEditingController();
  final _controllerDate = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validatorService = ValidatorService();
  final _signupService = SignupService();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          TextFieldUsernameAuth(
            controller: _controllerLICNumber,
            label: "License number",
            hintText: "Enter License number",
            icon: const Icon(Icons.inventory_rounded),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter License number!';
              } else if (!_validatorService.isValidLICNumber(value)) {
                return 'License number must be 12 characters';
              }
              return null;
            },
            readOnly: false,
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldUsernameAuth(
            controller: _controllerPhoneNumber,
            label: "Phone number",
            hintText: "Enter phone number",
            icon: const Icon(Icons.account_circle),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number!';
              } else if (!_validatorService.isValidPhoneNumber(value)) {
                return 'Phone number must be 10 characters';
              }
              return null;
            },
            readOnly: false,
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldUsernameAuth(
            controller: _controllerFullName,
            label: "Full name",
            hintText: "Enter full name",
            icon: const Icon(Icons.account_circle),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter full name!';
              }
              return null;
            },
            readOnly: false,
          ),
          const SizedBox(
            height: 15,
          ),
          SignupEnterInforDateText(
            controllerDate: _controllerDate,
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonAuth(
            text: "DONE",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Thực hiện cập nhật dữ liệu trước khi chuyển trang
                await _signupService.updateUser(
                  email: widget.email,
                  phoneNumber: _controllerPhoneNumber.text.trim(),
                  name: _controllerFullName.text.trim(),
                  dayOfBirth: _controllerDate.text.trim(),
                  gplx: _controllerLICNumber.text.trim(),
                );

                // Hiển thị thông báo thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  const SuccessNotification(
                          text: "Update information successfully.")
                      .buildSnackBar(),
                );

                // Chuyển trang sau khi cập nhật thành công
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupChangeAvatarScreen(
                      email: widget.email,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
