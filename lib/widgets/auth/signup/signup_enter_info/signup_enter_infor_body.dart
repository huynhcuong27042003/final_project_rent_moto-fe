import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/auth/validator_service.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/button_auth.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/signup/signup_enter_info/signup_enter_infor_date_text.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/signup/signup_enter_info/signup_enter_infor_genre.dart';
import 'package:final_project_rent_moto_fe/widgets/auth/text_field_username_auth.dart';

class SignupEnterInforBody extends StatefulWidget {
  const SignupEnterInforBody({super.key});

  @override
  State<SignupEnterInforBody> createState() => _SignupEnterInforBodyState();
}

class _SignupEnterInforBodyState extends State<SignupEnterInforBody> {
  final _controllerFullName = TextEditingController();
  final _controllerDate = TextEditingController();
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
          const SignupEnterInforGenre(),
          const SizedBox(
            height: 20,
          ),
          ButtonAuth(
            text: "DONE",
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
          )
        ],
      ),
    );
  }
}
