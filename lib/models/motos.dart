import 'package:final_project_rent_moto_fe/models/category_moto.dart';
import 'package:final_project_rent_moto_fe/models/company_moto.dart';
import 'package:final_project_rent_moto_fe/models/imformation_moto.dart';


class Motorcycle {
  final String _numberPlate;
  final CompanyMoto _companyMoto;
  final CategoryMoto _category; // Using CategoryMoto here
  final InformationMoto _informationMoto; // Assuming this is a corrected version of ImformationMoto
  final bool _isActive;
  final bool _isHide;

  // Constructor with named parameters
  Motorcycle({
    required String numberPlate,
    required CompanyMoto companyMoto,
    required CategoryMoto category,
    required InformationMoto informationMoto,
    required bool isActive,
    required bool isHide,
  })  : _numberPlate = numberPlate,
        _companyMoto = companyMoto,
        _category = category,
        _informationMoto = informationMoto,
        _isActive = isActive,
        _isHide = isHide;

  // Getters to access private properties
  String get numberPlate => _numberPlate;
  CompanyMoto get companyMoto => _companyMoto;
  CategoryMoto get category => _category;
  InformationMoto get informationMoto => _informationMoto;
  bool get isActive => _isActive;
  bool get isHide => _isHide;

  // Factory constructor for JSON deserialization
  factory Motorcycle.fromJson(Map<String, dynamic> json) {
    return Motorcycle(
      numberPlate: json['numberPlate'] ?? '',
      companyMoto: CompanyMoto.fromJson(json['companyMoto']),
      category: CategoryMoto.fromJson(json['category']),
      informationMoto: InformationMoto.fromJson(json['informationMoto']),
      isActive: json['isActive'] ?? false,
      isHide: json['isHide'] ?? false,
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'numberPlate': _numberPlate,
      'companyMoto': _companyMoto.toJson(),
      'category': _category.toJson(),
      'informationMoto': _informationMoto.toJson(),
      'isActive': _isActive,
      'isHide': _isHide,
    };
  }
}
