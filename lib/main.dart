import 'package:final_project_rent_moto_fe/screens/MotorCycle/motorcycles_list_by_admin_screen.dart';
import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Đảm bảo rằng Flutter đã được khởi tạo
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
