// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class GetBookingService {
  Future<Map<String, dynamic>?> fetchBookingById(String id) async {
    final String url =
        'http://10.0.2.2:3000/api/bookingMoto/$id'; // Thay localhost bằng địa chỉ IP thực tế khi chạy trên thiết bị thật.

    try {
      // Gửi yêu cầu GET tới API
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Giải mã JSON nếu thành công
        final data = jsonDecode(response.body);
        print('Booking data: $data');
        return data; // Trả về dữ liệu
      } else {
        // Xử lý lỗi nếu không thành công
        print('Failed to fetch booking: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Bắt lỗi nếu có sự cố
      print('Error fetching booking by ID: $error');
      return null;
    }
  }
}
