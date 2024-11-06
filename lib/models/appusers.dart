import 'package:final_project_rent_moto_fe/models/address.dart';
import 'package:final_project_rent_moto_fe/models/enum/roles.dart';
import 'package:final_project_rent_moto_fe/models/information.dart';

class AppUser {
  final String _email;
  final String _name;
  final String _phoneNumber;
  final Roles _role;
  final Address _address;
  final Information _information;
  final bool _isHide; // Thay Bool bằng bool

  AppUser({
    required String email,
    required String name,
    required String phoneNumber,
    required Roles role,
    required Address address,
    required Information information,
    required bool isHide, // Thay Bool bằng bool
  })  : _email = email,
        _name = name,
        _phoneNumber = phoneNumber,
        _role = role,
        _address = address,
        _information = information,
        _isHide = isHide;

  // Getters để truy cập các thuộc tính private
  String get email => _email;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  Roles get role => _role;
  Address get address => _address;
  Information get information => _information;
  bool get isHide => _isHide;

  // Factory constructor để tạo object từ JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      role: Roles.values[json['role']], // Giả định role là enum
      address: Address.fromJson(json['address']),
      information: Information.fromJson(json['information']),
      isHide: json['isHide'],
    );
  }

  // Phương thức chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'email': _email,
      'name': _name,
      'phoneNumber': _phoneNumber,
      'role': _role.index, // Lưu index của enum
      'address': _address.toJson(),
      'information': _information.toJson(),
      'isHide': _isHide,
    };
  }
}
