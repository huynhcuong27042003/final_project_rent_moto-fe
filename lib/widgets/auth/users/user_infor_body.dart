import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInforBody extends StatefulWidget {
  const UserInforBody({super.key});

  @override
  State<UserInforBody> createState() => _UserInforBodyState();
}

class _UserInforBodyState extends State<UserInforBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userName;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserNameAndAvatar();
  }

  Future<void> _fetchUserNameAndAvatar() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            userName = userData['information']?['name'];
            avatarUrl = userData['information']?['avatar'];
          });
        } else {
          print("No user found with this email.");
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background Image (1/4 screen height)
        Container(
          height: screenHeight * 0.23,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/image_background1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.2),
          ),
        ),

        // Scrollable Main Content
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.2), // Push avatar down

                // Avatar and Name
                CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl!)
                      : AssetImage('assets/avatar.png') as ImageProvider,
                ),

                SizedBox(height: 16),

                // User Name
                Text(
                  userName ?? 'User Name',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // First Rounded Box for Main Menu Items
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                            Icons.person, 'Tài khoản của tôi', context),
                        Divider(indent: 30.0, endIndent: 30.0),
                        _buildMenuItem(
                            Icons.car_rental, 'Đăng ký cho thuê xe', context),
                        Divider(indent: 30.0, endIndent: 30.0),
                        _buildMenuItem(Icons.favorite, 'Xe yêu thích', context),
                        Divider(indent: 30.0, endIndent: 30.0),
                        _buildMenuItem(
                            Icons.location_on, 'Địa chỉ của tôi', context),
                        Divider(indent: 30.0, endIndent: 30.0),
                        _buildMenuItem(
                            Icons.card_membership, 'Giấy phép lái xe', context),
                      ],
                    ),
                  ),
                ),

                // Second Rounded Box for Account Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.lock, 'Đổi mật khẩu', context),
                      ],
                    ),
                  ),
                ),

                // Centered Logout Button with 10px margin on top and bottom
                SizedBox(height: 10), // 10px space above the logout button
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle logout action
                  },
                  icon: Icon(Icons.logout,
                      color: Colors.red), // Red icon for logout
                  label: Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.red), // Red border
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                SizedBox(height: 10), // 10px space below the logout button
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // Handle tap event
      },
    );
  }
}
