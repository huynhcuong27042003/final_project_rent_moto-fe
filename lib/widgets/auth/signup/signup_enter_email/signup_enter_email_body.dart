import 'package:final_project_rent_moto_fe/screens/auth/signup/signup_enter_code_screen.dart';
import 'package:final_project_rent_moto_fe/services/auth/sendmail_service.dart';
import 'package:final_project_rent_moto_fe/services/auth/signup_service.dart';
import 'package:final_project_rent_moto_fe/services/auth/validator_service.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/button_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_username_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/notification/error_notification.dart';
import 'package:flutter/material.dart';

class SignupEnterEmailBody extends StatefulWidget {
  const SignupEnterEmailBody({super.key});

  @override
  State<SignupEnterEmailBody> createState() => _SignupEnterEmailBodyState();
}

class _SignupEnterEmailBodyState extends State<SignupEnterEmailBody> {
  final _controllerUserName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validatorService = ValidatorService();
  final SendMailService _sendMailService = SendMailService();
  final SignupService _signupService = SignupService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 150),
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
          const SizedBox(height: 20),
          ButtonAuth(
            text: "CONTINUE",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Check if the user exists asynchronously
                bool userExists = await _signupService
                    .checkIfUserExists(_controllerUserName.text.trim());

                if (!userExists) {
                  // Send the verification code if the user does not exist
                  await _sendMailService.sendCodeByMail(
                    context,
                    _controllerUserName.text.trim(),
                  );

                  // Navigate to the next screen after sending the verification code
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupEnterCodeScreen(
                        email: _controllerUserName.text.trim(),
                      ),
                    ),
                  );
                } else {
                  // Show an error notification if the user already exists
                  ScaffoldMessenger.of(context).showSnackBar(
                      const ErrorNotification(text: "Email is exist")
                          .buildSnackBar());
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
