import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/widgets/modals/form_day_month_year.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserInforMyaccount extends StatefulWidget {
  const UserInforMyaccount({super.key});

  @override
  State<UserInforMyaccount> createState() => _UserInforMyaccountState();
}

class _UserInforMyaccountState extends State<UserInforMyaccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  User? user;
  Map<String, dynamic>? userData;
  bool isEditing = false;
  bool isUploading = false;

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

  Future<void> _showDatePicker() async {
    String initialDate = dayOfBirthController.text;

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: FormSelectDayMonthYear(
            initialDate: initialDate,
            onDateSelected: (date) {
              setState(() {
                dayOfBirthController.text = date;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> saveUserData() async {
    // Name validation
    if (nameController.text.isEmpty || nameController.text.length < 2) {
      _showErrorDialog('Name must have at least 2 characters.');
      return;
    }

    // Phone number validation
    if (phoneNumberController.text.isEmpty ||
        phoneNumberController.text.length != 10) {
      _showErrorDialog('Phone number must have exactly 10 digits.');
      return;
    }

    // GPLX (driver's license) validation
    if (gplxController.text.isEmpty) {
      _showErrorDialog('Driver\'s license cannot be empty.');
      return;
    }
    if (!RegExp(r'^\d{12}$').hasMatch(gplxController.text)) {
      _showErrorDialog('Driver\'s license must have exactly 12 digits.');
      return;
    }

    // Date of birth validation
    if (dayOfBirthController.text.isEmpty) {
      _showErrorDialog('Date of birth cannot be empty.');
      return;
    }

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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeAvatar() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          isUploading = true;
        });

        // Lấy email từ FirebaseAuth
        final email = user?.email;

        if (email == null) {
          print("Email not found.");
          setState(() {
            isUploading = false;
          });
          return; // Trả về nếu không có email
        }

        // Truy vấn tài liệu người dùng từ Firestore theo email
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          // Nếu không tìm thấy người dùng với email này
          setState(() {
            isUploading = false;
          });
          print("No user found with this email.");
          return; // Dừng lại nếu không tìm thấy người dùng
        }

        // Lấy documentId của người dùng đầu tiên
        String userId = querySnapshot.docs.first.id;

        // Upload file lên Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('avatars/$userId');
        await storageRef.putFile(File(pickedFile.path));

        // Lấy URL tải xuống của avatar mới
        final downloadUrl = await storageRef.getDownloadURL();

        // Cập nhật URL của avatar vào Firestore
        await _firestore
            .collection('users')
            .doc(userId)
            .update({'information.avatar': downloadUrl});

        setState(() {
          // Cập nhật avatar mới cho người dùng trong UI
          userData?['information']?['avatar'] = downloadUrl;
          isUploading = false;
        });

        // Làm mới lại dữ liệu người dùng
        await _getUserData();

        print('Avatar updated successfully!');
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      print('Error updating avatar: $e');
    }
  }

  Widget _buildInfoField(
      String label, String value, TextEditingController controller,
      {bool isDateField = false}) {
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
              ? isDateField
                  ? GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        width: screenWidth - 20,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.text.isNotEmpty
                              ? controller.text
                              : 'Chọn ngày sinh',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nhập $label',
                      ),
                      style: const TextStyle(fontSize: 16),
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
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        userData?['information']?['avatar'] != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    userData!['information']!['avatar']),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person, size: 50),
                              ),
                        if (isEditing)
                          InkWell(
                            onTap: isUploading ? null : _changeAvatar,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        if (isUploading)
                          const Positioned.fill(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData?['email'] ?? 'No Email',
                    style: const TextStyle(fontSize: 18),
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
                            dayOfBirthController,
                            isDateField: true),
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
                          onPressed: saveUserData,
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
