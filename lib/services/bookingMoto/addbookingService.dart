import 'dart:convert';
import 'package:http/http.dart' as http;

class AddBookingservice {
  final String baseUrl = 'http://10.0.2.2:3000/api/bookingMoto';

  Future<Map<String, dynamic>> addBooking({
    required String email,
    required String numberPlate,
    required String bookingDate,
    required String returnDate,
    required int numberOfRentalDay,
  }) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'numberPlate': numberPlate,
          'bookingDate': bookingDate,
          'returnDate': returnDate,
          'numberOfRentalDay': numberOfRentalDay,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Trả về dữ liệu booking đã tạo
      } else {
        throw Exception('Failed to add booking: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error while calling addBooking: $error');
    }
  }
}
