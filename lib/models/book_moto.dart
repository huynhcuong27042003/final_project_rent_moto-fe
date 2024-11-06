import 'package:final_project_rent_moto_fe/models/appusers.dart';
import 'package:final_project_rent_moto_fe/models/motos.dart';

class BookMoto {
  final AppUser _appUser;
  final Motorcycle _moto;
  final DateTime _rentDate;
  final DateTime _returnDate;
  final int numberOfRentalDay; // Thay Int bằng int
  final bool isAccept;          // Thay Bool bằng bool
  final bool _isHide;          // Thay Bool bằng bool

  BookMoto({
    required AppUser appUser,
    required Motorcycle moto,
    required DateTime rentDate,
    required DateTime returnDate,
    required this.numberOfRentalDay,
    required this.isAccept,
    required bool isHide, // Thay Bool bằng bool
  })  : _appUser = appUser,
        _moto = moto,
        _rentDate = rentDate,
        _returnDate = returnDate,
        _isHide = isHide;

  // Getters
  AppUser get appUser => _appUser;
  Motorcycle get moto => _moto;
  DateTime get rentDate => _rentDate;
  DateTime get returnDate => _returnDate;
  bool get isHide => _isHide;

  // Factory constructor để tạo object từ JSON
  factory BookMoto.fromJson(Map<String, dynamic> json) {
    return BookMoto(
      appUser: AppUser.fromJson(json['appUser']),
      moto: Motorcycle.fromJson(json['moto']),
      rentDate: DateTime.parse(json['rentDate']), // Chuyển đổi từ chuỗi
      returnDate: DateTime.parse(json['returnDate']), // Chuyển đổi từ chuỗi
      numberOfRentalDay: json['numberOfRentalDay'],
      isAccept: json['isAccept'],
      isHide: json['isHide'],
    );
  }

  // Phương thức chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'appUser': _appUser.toJson(),
      'moto': _moto.toJson(),
      'rentDate': _rentDate.toIso8601String(), // Chuyển đổi thành chuỗi
      'returnDate': _returnDate.toIso8601String(), // Chuyển đổi thành chuỗi
      'numberOfRentalDay': numberOfRentalDay,
      'isAccept': isAccept,
      'isHide': _isHide,
    };
  }
}
