import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding the JSON response

class AcceptBookingService {
  // Method to accept a booking by bookingId
  Future<Map<String, dynamic>> acceptBooking(String bookingId) async {
    try {
      final response = await http.patch(
        Uri.parse(
            'http://10.0.2.2:3000/api/bookingMoto/accept/$bookingId'), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // If the server returns a successful response
        return json.decode(response.body); // Return the response body as a map
      } else {
        // If the response is not successful, return an error message
        return {'error': 'Failed to accept the booking.'};
      }
    } catch (e) {
      // Catch and return any error
      return {'error': 'Error: $e'};
    }
  }
}
