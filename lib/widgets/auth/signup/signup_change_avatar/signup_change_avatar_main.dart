import 'package:flutter/material.dart';

class SignupChangeAvatarMain extends StatelessWidget {
  const SignupChangeAvatarMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CircleAvatar(
          maxRadius: 100,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 0.1,
                color: Colors.black,
              ),
            ),
            child: TextButton(
              onPressed: () => {},
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
