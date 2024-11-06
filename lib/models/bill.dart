import 'package:final_project_rent_moto_fe/models/book_moto.dart';

class Bill {
  final BookMoto _bookMoto;
  final int _price;       
  final int _deposit;   
  final DateTime _createDate;

  Bill({
    required BookMoto bookMoto,
    required int price,    
    required int deposit,
    required DateTime createDate,
  })  : _bookMoto = bookMoto,
        _price = price,
        _deposit = deposit,
        _createDate = createDate;

  // Getters
  BookMoto get bookMoto => _bookMoto;
  int get price => _price;            // Thay Long bằng int
  int get deposit => _deposit;         // Thay Long bằng int
  DateTime get createDate => _createDate;

  // Factory constructor để tạo object từ JSON
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      bookMoto: BookMoto.fromJson(json['bookMoto']),
      price: json['price'],
      deposit: json['deposit'],
      createDate: DateTime.parse(json['createDate']), // Chuyển đổi từ chuỗi
    );
  }

  // Phương thức chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'bookMoto': _bookMoto.toJson(),
      'price': _price,
      'deposit': _deposit,
      'createDate': _createDate.toIso8601String(), // Chuyển đổi thành chuỗi
    };
  }
}
