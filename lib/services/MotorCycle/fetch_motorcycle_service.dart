// import 'package:cloud_firestore/cloud_firestore.dart';

// class FetchMotorcycleService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Lấy danh sách xe máy từ Firestore
//   Stream<List<Map<String, dynamic>>> fetchMotorcycles() {
//     return _firestore.collection('motorcycles').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return {
//           'id': doc.id,
//           'numberPlate': doc['numberPlate'] ?? 'N/A',
//           // Truy cập các trường trong 'companyMoto', 'category', và 'informationMoto'
//           'companyMoto': doc['companyMoto']?['name'] ?? 'N/A', // Lấy tên công ty từ 'companyMoto'
//           'category': doc['category']?['name'] ?? 'N/A', // Lấy tên danh mục từ 'category'
//           'nameMoto': doc['informationMoto']?['nameMoto'] ?? 'N/A', // Truy cập 'nameMoto' trong 'informationMoto'
//           'price': doc['informationMoto']?['price'] ?? 0, // Truy cập giá trong 'informationMoto'
//           'description': doc['informationMoto']?['description'] ?? 'N/A', // Mô tả trong 'informationMoto'
//           'energy': doc['informationMoto']?['energy'] ?? 'N/A', // Năng lượng trong 'informationMoto'
//           'vehicleMass': doc['informationMoto']?['vehicleMass'] ?? 0, // Khối lượng phương tiện trong 'informationMoto'
//           'images': List<String>.from(doc['informationMoto']?['images'] ?? []), // Mảng hình ảnh
//           'isActive': doc['isActive'] ?? false, // Trạng thái hoạt động
//           'isHide': doc['isHide'] ?? false, // Trạng thái ẩn
//         };
//       }).toList();
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class FetchMotorcycleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch list of motorcycles from Firestore
//   Future<List<Map<String, dynamic>>> fetchMotorcycles() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('motorcycles').get();
//       // Convert the snapshot data into a list of maps
//       return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     } catch (e) {
//       print("Error fetching motorcycles: $e");
//       return [];
//     }
//   }
// }

  Future<List<Map<String, dynamic>>> fetchMotorcycles() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('motorcycles').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Firestore tự động cung cấp 'id'
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching motorcycles: $e");
      return [];
    }
  }
}
