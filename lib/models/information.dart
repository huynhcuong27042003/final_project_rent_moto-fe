class Information {
  final String _name;
  final String _dayOfBirth; // Sửa lỗi chính tả: từ "Brith" thành "Birth"
  final String _avatar;
  final String _gplx;

  // Constructor với named parameters
  Information({
    required String name,
    required String dayOfBirth,
    required String avatar,
    required String gplx,
  })  : _name = name,
        _dayOfBirth = dayOfBirth,
        _avatar = avatar,
        _gplx = gplx;

  // Getters để truy cập các thuộc tính private
  String get name => _name;
  String get dayOfBirth => _dayOfBirth;
  String get avatar => _avatar;
  String get gplx => _gplx;

  // Factory constructor để tạo object từ JSON
  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      name: json['name'],
      dayOfBirth: json['dayOfBirth'],
      avatar: json['avatar'],
      gplx: json['gplx'],
    );
  }

  // Phương thức chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'dayOfBirth': _dayOfBirth,
      'avatar': _avatar,
      'gplx': _gplx,
    };
  }
}
