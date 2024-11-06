class CompanyMoto {
  final String _name;
  final bool _isHide;

  // Constructor with named parameters
  CompanyMoto({required String name, required bool isHide}) 
      : _name = name,
        _isHide = isHide;

  // Factory constructor to create object from JSON
  factory CompanyMoto.fromJson(Map<String, dynamic> json) {
    return CompanyMoto(
      name: json['name'],
      isHide: json['isHide'],
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'isHide': _isHide,
    };
  }
}
