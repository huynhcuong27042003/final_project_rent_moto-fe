// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMotorcycleService {
  // Base URL for your motorcycle API endpoint
  final String baseUrl = 'http://10.0.2.2:3000/api/motorcycle';

  Future<bool> addMotorcycle({
    required String numberPlate,
    required String companyMotoName,
    required String categoryName,
    required String nameMoto,
    required double price,
    required String description,
    required String energy,
    required double vehicleMass,
    required List<String> imagesMoto,
    bool isActive = false,
    bool isHide = false,
  }) async {
    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'numberPlate': numberPlate,
      'companyMoto': {'name': companyMotoName},
      'category': {'name': categoryName},
      'informationMoto': {
        'nameMoto': nameMoto,
        'price': price,
        'description': description,
        'energy': energy,
        'vehicleMass': vehicleMass,
        'imagesMoto': imagesMoto,
      },
      'isActive': isActive,
      'isHide': isHide,
    };

    try {
      // Sending the POST request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody), // Convert request body to JSON
      );

      // Return true if the request was successful (status code 201)
      return response.statusCode == 201;
    } catch (error) {
      print("Error adding motorcycle: $error");
      return false; // Return false if an error occurred
    }
  }
}
