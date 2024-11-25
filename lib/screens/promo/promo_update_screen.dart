import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PromoUpdateScreen extends StatefulWidget {
  final String documentId; // Nhận `documentId` từ trang danh sách

  PromoUpdateScreen(
      {required this.documentId}); // Constructor nhận `documentId`

  @override
  _PromoUpdateScreenState createState() => _PromoUpdateScreenState();
}

class _PromoUpdateScreenState extends State<PromoUpdateScreen> {
  late Map<String, dynamic> promoData; // Dữ liệu khuyến mãi
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  DateTime? _startDate; // Ngày bắt đầu
  DateTime? _endDate; // Ngày kết thúc
  String? _imageUrl; // Đường dẫn hình ảnh trong Firebase Storage
  bool _isHide = false; // Trạng thái ẩn hay hiển thị khuyến mãi

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getPromoData();
  }

  // Lấy dữ liệu khuyến mãi từ Firestore
  Future<void> _getPromoData() async {
    try {
      DocumentSnapshot promoSnapshot = await FirebaseFirestore.instance
          .collection('promotions')
          .doc(widget.documentId)
          .get();

      if (promoSnapshot.exists) {
        setState(() {
          promoData = promoSnapshot.data() as Map<String, dynamic>;
          _startDate = DateTime.parse(promoData['startDate']);
          _endDate = DateTime.parse(promoData['endDate']);
          _imageUrl = promoData['imageUrl']; // Lấy đường dẫn hình ảnh
          _isHide = promoData['isHide'] ?? false; // Lấy giá trị isHide
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Khuyến mãi không tồn tại!"),
        ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi khi tải dữ liệu: $e"),
      ));
    }
  }

  // Chọn hình ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileName = pickedFile.name;
      try {
        // Tải lên hình ảnh lên Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('promo_images/$fileName');
        await storageReference.putFile(File(pickedFile.path));

        // Lấy URL của hình ảnh đã tải lên
        String imageUrl = await storageReference.getDownloadURL();

        setState(() {
          _imageUrl = imageUrl; // Cập nhật URL hình ảnh
          promoData['imageUrl'] = imageUrl; // Cập nhật vào dữ liệu
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lỗi khi tải lên hình ảnh: $e"),
        ));
      }
    }
  }

  // Cập nhật khuyến mãi
  Future<void> _updatePromo(Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('promotions')
          .doc(widget.documentId)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Cập nhật khuyến mãi thành công!"),
      ));

      Navigator.pop(context); // Quay lại trang trước
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi khi cập nhật: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cập nhật khuyến mãi")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: promoData['name'],
                        decoration:
                            InputDecoration(labelText: 'Tên khuyến mãi'),
                        onChanged: (value) {
                          setState(() {
                            promoData['name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên khuyến mãi';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: promoData['code'],
                        decoration: InputDecoration(labelText: 'Mã khuyến mãi'),
                        onChanged: (value) {
                          setState(() {
                            promoData['code'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mã khuyến mãi';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: promoData['discount'].toString(),
                        decoration: InputDecoration(labelText: 'Giảm giá (%)'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            promoData['discount'] = int.tryParse(value) ?? 0;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tỷ lệ giảm giá';
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _startDate == null
                                  ? 'Chọn ngày bắt đầu'
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_startDate!),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Ngày bắt đầu',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _endDate == null
                                  ? 'Chọn ngày kết thúc'
                                  : DateFormat('yyyy-MM-dd').format(_endDate!),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Ngày kết thúc',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                      // Hiển thị hình ảnh hiện tại hoặc chọn hình ảnh mới
                      SizedBox(height: 20),
                      _imageUrl == null
                          ? Text("Chưa có hình ảnh")
                          : Image.network(_imageUrl!),
                      ElevatedButton(
                        onPressed: _pickImage, // Chọn hình ảnh
                        child: Text("Chọn hình ảnh mới"),
                      ),
                      SizedBox(height: 20),
                      // Thêm phần toggle "isHide"
                      SwitchListTile(
                        title: Text("Ẩn khuyến mãi"),
                        value: _isHide,
                        onChanged: (value) {
                          setState(() {
                            _isHide = value;
                            promoData['isHide'] = _isHide; // Cập nhật giá trị
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _updatePromo(promoData); // Cập nhật khuyến mãi
                          }
                        },
                        child: Text("Cập nhật"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Hàm chọn ngày bắt đầu
  Future<void> _selectStartDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedStartDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? currentDate,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 5),
    );
    if (selectedStartDate != null && selectedStartDate != _startDate) {
      setState(() {
        _startDate = selectedStartDate;
        promoData['startDate'] = DateFormat('yyyy-MM-dd').format(_startDate!);
      });
    }
  }

  // Hàm chọn ngày kết thúc
  Future<void> _selectEndDate(BuildContext context) async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Vui lòng chọn ngày bắt đầu trước"),
      ));
      return;
    }
    DateTime? selectedEndDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime(_startDate!.year + 5),
    );
    if (selectedEndDate != null && selectedEndDate != _endDate) {
      setState(() {
        _endDate = selectedEndDate;
        promoData['endDate'] = DateFormat('yyyy-MM-dd').format(_endDate!);
      });
    }
  }
}
