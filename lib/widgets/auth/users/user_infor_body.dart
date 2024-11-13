import 'package:final_project_rent_moto_fe/widgets/auth/users/user_infor_myaccount_form.dart';
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
          print("Không tìm thấy người dùng với email này.");
        }
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu người dùng: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Hình nền (chiếm 1/4 chiều cao màn hình)
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

        // Nội dung chính có thể cuộn
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.2), // Đẩy avatar xuống

                // Avatar và tên người dùng
                CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl!)
                      : AssetImage('assets/avatar.png') as ImageProvider,
                ),

                SizedBox(height: 16),

                // Tên người dùng
                Text(
                  userName ?? 'Tên người dùng',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Hộp tròn đầu tiên cho các mục menu chính
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
                          offset: Offset(0, 3), // thay đổi vị trí bóng
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

                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                SizedBox(height: 10),
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
        if (title == 'Tài khoản của tôi') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserInforMyaccount()),
          );
        }
      },
    );
  }
}
