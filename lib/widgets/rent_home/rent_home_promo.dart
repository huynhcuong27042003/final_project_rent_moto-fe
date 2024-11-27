import 'package:flutter/material.dart';

class RentHomePromo extends StatefulWidget {
  const RentHomePromo({super.key});

  @override
  State<RentHomePromo> createState() => _RentHomePromoState();
}

class _RentHomePromoState extends State<RentHomePromo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chương trình khuyến mãi",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8)),
                  width: 270, // Đặt kích thước để nội dung hiển thị rõ ràng hơn
                  height: 150,
                  child: const Center(
                    child: Text("Promo"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8)),
                  width: 270, // Đặt kích thước để nội dung hiển thị rõ ràng hơn
                  height: 150,
                  child: const Center(
                    child: Text("Promo"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8)),
                  width: 270, // Đặt kích thước để nội dung hiển thị rõ ràng hơn
                  height: 150,
                  child: const Center(
                    child: Text("Promo"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
