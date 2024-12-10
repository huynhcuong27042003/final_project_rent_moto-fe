import 'package:final_project_rent_moto_fe/services/review/add_review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final String numberPlate;
  const ReviewScreen({super.key, required this.numberPlate});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int rating = 0;
  final _controllerComment = TextEditingController();
  final _addReviewService = AddReviewService();
  // Thông tin xe máy
  String bikeModel = "Yamaha R15";
  String bikePlate = "70D1-754.91";
  String bikeType = "Xe thể thao";
  String bikeImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/final-project-e5878.appspot.com/o/motorcycle_images%2F1732703289897.jpg?alt=media&token=3473540b-ef74-4cb5-b6db-de4d7aa91cf9"; // Thay đường dẫn ảnh thật

  void updateRating(int newRating) {
    setState(() {
      rating = newRating;
    });
  }

  void _addReview() {
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        _addReviewService.addReview(
          email,
          widget.numberPlate,
          rating,
          _controllerComment.text.trim(),
        );
        print("Đánh giá thành công");
      } else {
        print("Đánh giá không thành công");
      }
    } catch (e) {
      print("Không đánh giá được lỗi :$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đánh giá",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFFAD15),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Sử dụng SingleChildScrollView để cuộn màn hình khi mở bàn phím
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần hiển thị thông tin xe máy
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hình ảnh xe
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          bikeImageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Thông tin xe máy",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Mẫu xe: $bikeModel"),
                      Text("Biển số: $bikePlate"),
                      Text("Loại xe: $bikeType"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Phần đánh giá sao
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < rating ? Colors.yellow : Colors.grey,
                      size: 40,
                    ),
                    onPressed: () => updateRating(index + 1),
                  );
                }),
              ),
              SizedBox(height: 20),

              // Phần nhập bình luận
              TextFormField(
                controller: _controllerComment,
                decoration: InputDecoration(
                  labelText: 'Viết đánh giá của bạn...',
                  border: OutlineInputBorder(),
                  hintText: 'Nhập ý kiến của bạn tại đây',
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20),

              // Nút gửi đánh giá
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý khi người dùng gửi đánh giá
                    _addReview();
                  },
                  child: Text('Gửi Đánh Giá'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFAD15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}