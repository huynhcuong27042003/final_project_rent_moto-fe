import 'dart:convert';
import 'package:http/http.dart' as http;

// Define the URL for your backend API
const String apiUrl =
    'http://10.0.2.2:3000/api/invoices'; // Replace with your actual server URL

class InvoiceService {
  static Future<String> addInvoice(String bookingId, String totalAmount,
      String motorbikeRentalDeposit) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'bookingId': bookingId,
          'totalAmount': totalAmount,
          'motorbikeRentalDeposit': motorbikeRentalDeposit,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['invoiceId']; // Return the invoiceId
      } else {
        throw Exception('Failed to add invoice');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
