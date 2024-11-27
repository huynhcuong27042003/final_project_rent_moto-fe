// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_rent_moto_fe/screens/MotorCycle/motorcycles_list_screen.dart';
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
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;

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

  Future<String?> _fetchUserRole() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          return userData['role']; // Return the user's role from Firestore
        }
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return null; // Return null if there was an error or no role found
  }

  Stream<int> fetchMotorcycleCount() {
    return FirebaseFirestore.instance
        .collection('motorcycles')
        .where('isHide', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
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
                userName != null
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
                        "Chào mừng!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
              ],
            ),
            if (userName != null)
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
                  StreamBuilder<int>(
                    stream: fetchMotorcycleCount(),
                    builder: (context, snapshot) {
                      int count = snapshot.data ?? 0;

                      return IconButton(
                        onPressed: () async {
                          try {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser != null) {
                              final userEmail = currentUser.email;
                              final userSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .where('email', isEqualTo: userEmail)
                                  .get();

                              if (userSnapshot.docs.isNotEmpty) {
                                final userData = userSnapshot.docs.first.data();
                                final role = userData[
                                    'role']; // Fetch user role directly here

                                // Only proceed if the role is 'employee' and the count is greater than 0
                                if (role == 'employee' && count > 0) {
                                  final RenderBox renderBox =
                                      context.findRenderObject() as RenderBox;
                                  final position =
                                      renderBox.localToGlobal(Offset.zero);
                                  final size = renderBox.size;

                                  showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      position.dx + size.width - 50,
                                      position.dy + size.height,
                                      0,
                                      0,
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        child: SizedBox(
                                          width: 200,
                                          height: 400,
                                          child: MotorcyclesListScreen(),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (role != 'employee') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Access restricted to employees only.'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('No new notifications.'),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('No user found with this email.'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('No current user is logged in.'),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error fetching user data: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Error fetching user data. Please try again later.'),
                              ),
                            );
                          }
                        },
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.notifications,
                              color: Colors.blueGrey,
                            ),
                            // Only show the count badge for 'employee' role and if count > 0
                            if (count >
                                0) // Ensure that count is greater than 0
                              Positioned(
                                top: 0,
                                right: 0,
                                child: FutureBuilder<String?>(
                                  future:
                                      _fetchUserRole(), // Fetch the user's role asynchronously
                                  builder: (context, roleSnapshot) {
                                    if (roleSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(); // Show nothing while loading
                                    }

                                    // Only show the count badge for 'employee' role
                                    if (roleSnapshot.hasData &&
                                        roleSnapshot.data == 'employee') {
                                      return CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          count.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(); // Don't show anything if the user is not an 'employee'
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
