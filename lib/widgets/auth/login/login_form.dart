import 'package:final_project_rent_moto_fe/screens/MotorCycle/motorcycle_list_by_user.dart';
import 'package:final_project_rent_moto_fe/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:final_project_rent_moto_fe/screens/auth/signup/signup_enter_email_screen.dart';
import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:final_project_rent_moto_fe/services/auth/login_service.dart';
import 'package:final_project_rent_moto_fe/services/auth/validator_service.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/button_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/button_link_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_password_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_username_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _validatorService = ValidatorService();
  final LoginService _loginService = LoginService();

  void _login() async {
    final email = _controllerUserEmail.text;
    final password = _passwordController.text;

    try {
      final response = await _loginService.login(email, password);
      // Kiểm tra nếu đăng nhập thành công
      if (response != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLogin', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MotorcycleListByUser(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Đăng nhập thành công.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        _showErrorMessage('Email hoặc mật khẩu không đúng');
      }
    } catch (e) {
      _showErrorMessage('Đăng nhập thất bại.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFieldUsernameAuth(
            controller: _controllerUserEmail,
            label: 'Email',
            hintText: ' Nhập email',
            icon: const Icon(Icons.person_4_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email không được trống!';
              } else if (!_validatorService.isValidEmail(value)) {
                return 'Định dạng email không đúng';
              }
              return null;
            },
            readOnly: false,
          ),
          const SizedBox(height: 15),
          TextFieldPasswordAuth(
            controller: _passwordController,
            label: 'Mật khẩu',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mật khẩu không được trống!';
              } else if (!_validatorService.isValidPassword(value)) {
                return 'Mật khẩu phải trên 8 ký tự. Gồm 1 chữ hoa, chữ thường, và số.';
              }
              return null;
            },
            hintText: 'Nhập mật khẩu',
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          ButtonAuth(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Nếu form hợp lệ, thực hiện logic đăng nhập
                _login();
              }
            },
            text: 'ĐĂNG NHẬP',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Chưa có tài khoản?",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(width: 20),
          ButtonLinkAuth(
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupEnterEmailScreen(),
                      ),
                    )
                  },
              text: "Đăng ký")
        ],
      ),
    );
  }
}
