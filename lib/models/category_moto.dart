class CategoryMoto {
  final String name;
  final bool isHide;

  // Constructor
  CategoryMoto({
    required this.name,
    required this.isHide,
  });

  // Factory constructor to create a CategoryMoto from JSON (Firestore response)
  factory CategoryMoto.fromJson(Map<String, dynamic> json) {
    // Check if required fields exist in the JSON
    if (json['name'] == null || json['isHide'] == null) {
      throw Exception('Name or isHide is missing in JSON data');
    }

    return CategoryMoto(
      name: json['name'],
      isHide: json['isHide'],
    );
  }

  // Method to convert CategoryMoto to JSON (for sending to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isHide': isHide,
    };
  }
}
