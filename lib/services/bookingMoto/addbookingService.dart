import 'dart:convert';
import 'package:http/http.dart' as http;

class AddBookingService {
  final String baseUrl = 'http://10.0.2.2:3000/api/bookingMoto';

  Future<Map<String, dynamic>> addBooking({
    required String email,
    required String numberPlate,
    required DateTime bookingDate,
    required DateTime returnDate,
    required int numberOfRentalDay,
    bool isAccept = false,
    bool isHide = false,
  }) async {
    final url = Uri.parse(baseUrl);
    print("Ngayn nhan: $bookingDate");
    final adjustedBookingDate = bookingDate.toUtc().add(Duration(hours: 7));
    final adjustedReturnDate = returnDate.toUtc().add(Duration(hours: 7));
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'numberPlate': numberPlate,
          'bookingDate':
              adjustedBookingDate.toIso8601String(), // ISO 8601 cho UTC
          'returnDate': adjustedReturnDate.toIso8601String(),
          'numberOfRentalDay': numberOfRentalDay,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add booking: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error while calling addBooking: $error');
    }
  }
}
