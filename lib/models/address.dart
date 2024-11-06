class Address {
  final String _streetName;
  final String _city;
  final String _district;
  final String _ward;

  Address({
    required String streetName,
    required String city,
    required String district,
    required String ward,
  })  : _streetName = streetName,
        _city = city,
        _district = district,
        _ward = ward;

  // Getters
  String get streetName => _streetName;
  String get city => _city;
  String get district => _district;
  String get ward => _ward;

  @override
  String toString() {
    return 'Address: $_streetName, $_ward, $_district, $_city';
  }

  // Factory constructor để tạo object từ JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      streetName: json['streetName'],
      city: json['city'],
      district: json['district'],
      ward: json['ward'],
    );
  }

  // Phương thức chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'streetName': _streetName,
      'city': _city,
      'district': _district,
      'ward': _ward,
    };
  }
}
