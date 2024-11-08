import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMotorcycleService {
  // Future<bool> updateMotorcycle({
  Future<bool> updateMotorcycle({
    required String id,
    required String numberPlate,
    required String companyMotoName,
    required String categoryName,
    required String nameMoto,
    required double price,
    required String description,
    required String energy,
    required double vehicleMass,
    required List<String> imagesMoto,
    required bool isHide,
    required bool isActive,
  }) async {
    try {
      // Cập nhật thông tin xe máy vào Firestore
      DocumentReference ref =
          FirebaseFirestore.instance.collection('motorcycles').doc(id);
      Map<String, dynamic> updateData = {
        'numberPlate': numberPlate,
        'companyMoto': {'name': companyMotoName},
        'category': {'name': categoryName},
        'informationMoto': {
          'nameMoto': nameMoto,
          'price': price,
          'description': description,
          'energy': energy,
          'vehicleMass': vehicleMass,
        },
        'images': imagesMoto,
        'isHide': isHide, // Cập nhật isHide
        'isActive': isActive,
      };

      // Nếu có ảnh mới, cập nhật trường ảnh trong Firestore
      if (imagesMoto != null && imagesMoto.isNotEmpty) {
        updateData['images'] = imagesMoto;
      }

      // Cập nhật dữ liệu vào Firestore
      await ref.update(updateData);
      return true; // Trả về true nếu thành công
    } catch (e) {
      print('Error updating motorcycle: $e');
      return false; // Trả về false nếu có lỗi
    }
  }
}
