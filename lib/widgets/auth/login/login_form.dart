import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/auth/validator_service.dart'; // Import validator
import 'package:final_project_rent_moto_fe/widgets/auth/button_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/button_link_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_password_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_username_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _controllerUserEmail = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final _validatorService =
      ValidatorService(); // Tạo instance của ValidatorService

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFieldUsernameAuth(
            controller: _controllerUserEmail,
            label: 'Username',
            hintText: 'Enter email',
            icon: const Icon(Icons.person_4_outlined),
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
            height: 15,
          ),
          TextFieldPasswordAuth(
            controller: _passwordController,
            label: 'Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password!';
              } else if (!_validatorService.isValidPassword(value)) {
                return 'Password must be at least 8 characters, with uppercase, lowercase, and digits.';
              }
              return null;
            },
            hintText: 'Enter password',
            obscureText: _obscureText,
            readOnly: false,
            toggleObscureText: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          ButtonAuth(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Nếu form hợp lệ, thực hiện logic đăng nhập
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            text: 'SIGIN',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Don't have an account?",
                  style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          ButtonLinkAuth(onPressed: () => {}, text: "Signup")
        ],
      ),
    );
  }
}
