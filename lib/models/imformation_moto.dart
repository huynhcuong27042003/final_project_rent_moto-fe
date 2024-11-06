import 'package:final_project_rent_moto_fe/models/enum/enery.dart';
import 'package:final_project_rent_moto_fe/models/images_moto.dart';

class InformationMoto {
  final String _nameMoto;
  final ImagesMoto _imagesMoto;
  final int _price;  // Use int instead of Long
  final String _description;
  final Enery _enery;
  final String _vehicleMass;

  // Constructor with named parameters
  InformationMoto({
    required String nameMoto,
    required ImagesMoto imagesMoto,
    required int price, // Change Long to int
    required String description,
    required Enery enery,
    required String vehicleMass,
  })  : _nameMoto = nameMoto,
        _imagesMoto = imagesMoto,
        _price = price,
        _description = description,
        _enery = enery,
        _vehicleMass = vehicleMass;

  // Getters for accessing private properties
  String get nameMoto => _nameMoto;
  ImagesMoto get imagesMoto => _imagesMoto;
  int get price => _price; // Correct type
  String get description => _description;
  Enery get enery => _enery;
  String get vehicleMass => _vehicleMass;

  // Factory constructor to create object from JSON
  factory InformationMoto.fromJson(Map<String, dynamic> json) {
    return InformationMoto(
      nameMoto: json['nameMoto'] ?? '',
      imagesMoto: ImagesMoto.fromJson(json['imagesMoto']),
      price: json['price'] ?? 0, // Handle potential null values
      description: json['description'] ?? '',
      enery: Enery.values[json['enery'] ?? 0], // Make sure this is handled correctly
      vehicleMass: json['vehicleMass'] ?? '',
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'nameMoto': _nameMoto,
      'imagesMoto': _imagesMoto.toJson(),
      'price': _price,
      'description': _description,
      'enery': _enery.index, // Assuming you want to save the index
      'vehicleMass': _vehicleMass,
    };
  }
}
