class ImagesMoto {
  final String _image1;
  final String _image2;
  final String _image3;
  final String _image4;

  // Constructor với named parameters
  ImagesMoto({
    required String image1,
    required String image2,
    required String image3,
    required String image4,
  })  : _image1 = image1,
        _image2 = image2,
        _image3 = image3,
        _image4 = image4;

  // Getters để truy cập các thuộc tính private
  String get image1 => _image1;
  String get image2 => _image2;
  String get image3 => _image3;
  String get image4 => _image4;

  // Factory constructor để tạo object từ JSON
  factory ImagesMoto.fromJson(Map<String, dynamic> json) {
    return ImagesMoto(
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      image4: json['image4'],
    );
  }

  // Phương thức chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'image1': _image1,
      'image2': _image2,
      'image3': _image3,
      'image4': _image4,
    };
  }
}
