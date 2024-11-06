import 'package:flutter/material.dart';

class SignupChangAvatarInfor extends StatelessWidget {
  const SignupChangAvatarInfor({super.key});

  Widget fieldInfoRow(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            sub,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 350,
      decoration: const BoxDecoration(
        color: Color.fromARGB(77, 196, 198, 198),
      ),
      child: Card(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(162, 255, 255, 255),
                Color.fromARGB(82, 255, 173, 21),
                Color.fromARGB(123, 255, 173, 21),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.max, // Đảm bảo row chiếm toàn bộ không gian
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 100,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "YOUR INFORMATION",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Gọi fieldInfoRow ở đây
                    fieldInfoRow("Full name", "HUỲNH MINH CƯỜNG"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        // Column cho Date of birth
                        fieldInfoRow("Date of birth", "27/04/2003"),
                        const SizedBox(width: 60), // Thêm khoảng cách
                        // Column cho Genre
                        fieldInfoRow("Genre", "Male"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
