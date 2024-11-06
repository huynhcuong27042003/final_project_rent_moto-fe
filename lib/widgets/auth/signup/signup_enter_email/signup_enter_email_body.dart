import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/auth/validator_service.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/button_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_username_auth.dart';

class SignupEnterEmailBody extends StatefulWidget {
  const SignupEnterEmailBody({super.key});

  @override
  State<SignupEnterEmailBody> createState() => _SignupEnterEmailBodyState();
}

class _SignupEnterEmailBodyState extends State<SignupEnterEmailBody> {
  final _controllerUserName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validatorService = ValidatorService();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          TextFieldUsernameAuth(
            controller: _controllerUserName,
            label: "Email",
            hintText: "Enter email",
            icon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email!';
              } else if (!_validatorService.isValidEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            readOnly: false,
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonAuth(
            text: "CONTINUE",
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
          )
        ],
      ),
    );
  }
}
