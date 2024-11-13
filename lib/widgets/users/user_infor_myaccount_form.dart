import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding

class UserInforMyaccount extends StatefulWidget {
  const UserInforMyaccount({super.key});

  @override
  State<UserInforMyaccount> createState() => _UserInforMyaccountState();
}

class _UserInforMyaccountState extends State<UserInforMyaccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic>? userData;
  bool isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController dayOfBirthController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController gplxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: user!.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            userData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
            _initializeControllers();
          });
        } else {
          print("Không tìm thấy người dùng với email này.");
        }
      }
    } catch (e) {
      print("Lỗi khi tải dữ liệu người dùng: $e");
    }
  }

  void _initializeControllers() {
    nameController.text = userData?['information']?['name'] ?? '';
    dayOfBirthController.text = userData?['information']?['dayOfBirth'] ?? '';
    phoneNumberController.text = userData?['phoneNumber'] ?? '';
    gplxController.text = userData?['information']?['gplx'] ?? '';
  }

  // API call to save user data
  Future<void> saveUserData() async {
    try {
      final email = user?.email;
      final url = 'http://10.0.2.2:3000/api/appuser/$email';

      final updatedData = {
        "information": {
          "name": nameController.text,
          "dayOfBirth": dayOfBirthController.text,
          "gplx": gplxController.text,
        },
        "phoneNumber": phoneNumberController.text,
      };

      final response = await http.patch(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        print('User data updated successfully!');

        // Quay lại màn hình trước và truyền thông tin đã cập nhật
        Navigator.pop(context, {
          'name': nameController.text,
          'dayOfBirth': dayOfBirthController.text,
          'phoneNumber': phoneNumberController.text,
          'gplx': gplxController.text,
        });
      } else {
        print('Failed to update user data: ${response.body}');
      }
    } catch (e) {
      print('Error when sending request: $e');
    }
  }

  Widget _buildInfoField(
      String label, String value, TextEditingController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          isEditing
              ? Container(
                  width: screenWidth - 20,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                )
              : Container(
                  width: screenWidth - 20,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value.isNotEmpty ? value : 'Chưa xác thực',
                    style: TextStyle(
                      color: value.isEmpty ? Colors.red : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MyAccount'),
        backgroundColor: const Color(0xFFF49C21),
        actions: isEditing
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                ),
              ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        userData?['information']?['avatar'] != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    userData!['information']!['avatar'] ?? ''),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person, size: 50),
                              ),
                        const SizedBox(height: 16),
                        Text(
                          userData?['email'] ?? 'No Email',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        _buildInfoField(
                            'Họ tên',
                            userData?['information']?['name'] ?? '',
                            nameController),
                        _buildInfoField(
                            'Ngày sinh',
                            userData?['information']?['dayOfBirth'] ?? '',
                            dayOfBirthController),
                        _buildInfoField(
                            'Số điện thoại',
                            userData?['phoneNumber'] ?? '',
                            phoneNumberController),
                        _buildInfoField(
                            'Giấy phép lái xe',
                            userData?['information']?['gplx'] ?? '',
                            gplxController),
                      ],
                    ),
                  ),
                  if (isEditing)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isEditing = false;
                              _initializeControllers();
                            });
                          },
                          child: const Text("Hủy"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            saveUserData();
                          },
                          child: const Text("Lưu"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
