import 'package:final_project_rent_moto_fe/widgets/rent_home/rent_home_search_by_location.dart';
import 'package:flutter/material.dart';

class RentHomeFeaturedLocation extends StatelessWidget {
  RentHomeFeaturedLocation({super.key});

  final List<String> images = [
    'assets/images/quan1.png',
    'assets/images/q2.png',
    'assets/images/q3.png',
    'assets/images/q4.png',
    'assets/images/q5.png',
    'assets/images/q6.png',
    'assets/images/q7.png',
    'assets/images/q8.png',
    'assets/images/q10.png',
    'assets/images/q11.png',
    'assets/images/q12.png',
    'assets/images/qgv.png',
    'assets/images/qtb.png',
    'assets/images/qbt.png',
    'assets/images/qbinhthanh.png',
    'assets/images/qtp.png',
    'assets/images/qpn.png',
  ];

  final List<String> locations = [
    'Quận 1',
    'Thành phố Thủ Đức',
    'Quận 3',
    'Quận 4',
    'Quận 5',
    'Quận 6',
    'Quận 7',
    'Quận 8',
    'Quận 10',
    'Quận 11',
    'Quận 12',
    'Quận Gò Vấp',
    'Quận Tân Bình',
    'Quận Bình Tân',
    'Quận Bình Thạnh',
    'Quận Tân Phú',
    'Quận Phú Nhuận',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Cách đáy 20px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trái các phần tử
        children: [
          const Text(
            "Địa điểm nổi bật",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5), // Khoảng cách giữa tiêu đề và ảnh
          // SingleChildScrollView cho phép lướt qua các khung ảnh theo chiều ngang
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Lướt ngang
            child: Row(
              children: List.generate(images.length, (index) {
                return GestureDetector(
                  onTap: () {
                    // Chuyển hướng đến màn hình chi tiết quận
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RentHomeSearchByLocation(
                            location: locations[index]),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: const EdgeInsets.only(
                        right: 10), // Khoảng cách giữa các ảnh
                    height: 230, // Chiều cao của ảnh
                    child: ClipPath(
                      clipper:
                          DiagonalClipper(), // Dùng custom clipper để cắt ảnh chéo
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(13), // Bo tròn góc ảnh
                        child: Stack(
                          fit: StackFit
                              .expand, // Đảm bảo Stack chiếm toàn bộ không gian
                          children: [
                            Image.asset(
                              images[
                                  index], // Đọc đường dẫn ảnh từ danh sách images
                              fit: BoxFit.cover, // Đảm bảo ảnh phủ đầy khung
                            ),
                            Positioned(
                              bottom: 10, // Cách đáy 10px
                              left: 10, // Cách trái 10px
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                color: Colors.grey
                                    .withOpacity(0.6), // Nền mờ cho text
                                child: Text(
                                  locations[
                                      index], // Đọc tên địa điểm từ danh sách locations
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper để cắt ảnh theo đường chéo
class DiagonalClipper extends CustomClipper<Path> {
  final double cutPercentageX; // Tỷ lệ cắt theo chiều ngang
  final double cutPercentageY; // Tỷ lệ cắt theo chiều dọc

  DiagonalClipper({
    this.cutPercentageX = 1 / 3, // Tỷ lệ cắt theo chiều ngang mặc định là 1/3
    this.cutPercentageY = 1 / 3, // Tỷ lệ cắt theo chiều dọc mặc định là 1/3
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    double cutPointX = size.width * cutPercentageX; // Điểm cắt theo chiều ngang
    double cutPointY = size.height * cutPercentageY; // Điểm cắt theo chiều dọc

    path.moveTo(0, 0); // Bắt đầu từ góc trên bên trái
    path.lineTo(size.width - cutPointX, 0); // Cắt ngang từ góc trên bên phải
    path.lineTo(size.width, cutPointY); // Cắt dọc xuống góc trên bên phải
    path.lineTo(size.width, size.height); // Kéo xuống góc dưới bên phải
    path.lineTo(0, size.height); // Kéo sang góc dưới bên trái
    path.close(); // Đóng lại đường path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // Không cần tái cắt khi thay đổi
  }
}
