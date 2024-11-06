// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';

class FetchCategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchCategoryMotos() {
    // Sử dụng Stream để lắng nghe các thay đổi từ Firestore
    return _firestore.collection('categoryMotos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Lấy ID của tài liệu
          ...doc.data() as Map<String, dynamic>, // Lấy dữ liệu tài liệu
        };
      }).toList();
    });
  }
}





