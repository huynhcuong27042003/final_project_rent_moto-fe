class CategoryMoto {
  // Private attributes
  final String _name;
  final bool _isHide;

  // Constructor with named parameters
  CategoryMoto({required String name, required bool isHide})
      : _name = name,
        _isHide = isHide;

  // Factory method to create an object from JSON
  factory CategoryMoto.fromJson(Map<String, dynamic> json) {
    return CategoryMoto(
      name: json['name'],
      isHide: json['isHide'],
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'isHide': _isHide,
    };
  }

  // Getters to access private attributes
  String get name => _name;
  bool get isHide => _isHide;
}
