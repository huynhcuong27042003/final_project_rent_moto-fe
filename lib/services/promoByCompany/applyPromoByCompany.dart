import 'package:cloud_firestore/cloud_firestore.dart';

class ApplyPromoByCompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy thông tin khuyến mãi theo công ty
  Future<List<Map<String, dynamic>>> getPromotedMotorcycles() async {
    List<Map<String, dynamic>> promotedMotorcycles = [];
    try {
      final DateTime now = DateTime.now();

      QuerySnapshot promotionsSnapshot = await _firestore
          .collection('promotionsByCompany')
          .where('endDate', isGreaterThanOrEqualTo: now.toIso8601String())
          .get();

      // Duyệt qua danh sách khuyến mãi
      for (var promoDoc in promotionsSnapshot.docs) {
        final promoData = promoDoc.data() as Map<String, dynamic>;
        final companyName = promoData['companyMoto']['name'];

        // Lấy ngày bắt đầu khuyến mãi
        DateTime startDate = DateTime.parse(promoData['startDate']);

        // Kiểm tra nếu ngày bắt đầu khuyến mãi sau ngày hôm nay thì bỏ qua khuyến mãi này
        if (startDate.isAfter(now)) {
          continue; // Bỏ qua khuyến mãi này nếu ngày bắt đầu sau ngày hôm nay
        }

        // Kiểm tra thuộc tính 'ishide', nếu là true thì bỏ qua khuyến mãi này
        if (promoData['isHide'] == true) {
          continue; // Bỏ qua khuyến mãi này nếu 'ishide' là true
        }

        // Lấy danh sách xe từ bộ sưu tập `motorcycles` khớp với công ty
        QuerySnapshot motorcycleSnapshot = await _firestore
            .collection('motorcycles')
            .where('companyMoto.name', isEqualTo: companyName)
            .get();

        // Duyệt qua danh sách xe và thêm thông tin khuyến mãi
        for (var motoDoc in motorcycleSnapshot.docs) {
          final motoData = motoDoc.data() as Map<String, dynamic>;

          // Thêm thông tin khuyến mãi vào dữ liệu xe
          motoData['promotion'] = {
            'promoName': promoData['promoName'],
            'percentage': promoData['percentage'],
            'endDate': promoData['endDate'],
          };

          promotedMotorcycles.add(motoData);
        }
      }
    } catch (e) {
      print('Error fetching promoted motorcycles: $e');
    }

    return promotedMotorcycles;
  }
}
