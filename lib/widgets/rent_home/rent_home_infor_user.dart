// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_rent_moto_fe/screens/favorite_list/list_favorite_by_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentHomeInforUser extends StatefulWidget {
  const RentHomeInforUser({super.key});

  @override
  State<RentHomeInforUser> createState() => _RentHomeInforUserState();
}

class _RentHomeInforUserState extends State<RentHomeInforUser> {
  String? userName;
  String? phoneNumber;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;

    if (isLogin) {
      fetchDataUser();
    }
  }

  Future<void> fetchDataUser() async {
    try {
      // Lấy currentUser từ FirebaseAuth
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;

        // Truy vấn thông tin người dùng từ Firestore
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          setState(() {
            userName = userData['information']['name'] ?? 'Unknown';
            phoneNumber = userData['phoneNumber'] ?? 'No phone';
            avatarUrl = userData['information']['avatar'];
          });
        }
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 15,
      top: 30,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orangeAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width - 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 25,
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 15),
                avatarUrl != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName ?? "Loading...",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            phoneNumber ?? "Loading...",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
              ],
            ),
            if (avatarUrl != null)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListFavoriteByUser(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.favorite,
                      size: 18,
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 12,
                    color: Colors.red,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
