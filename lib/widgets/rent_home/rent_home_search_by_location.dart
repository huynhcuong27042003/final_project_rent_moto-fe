import 'package:final_project_rent_moto_fe/screens/detail/detail_moto_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentHomeSearchByLocation extends StatefulWidget {
  final String location;

  const RentHomeSearchByLocation({super.key, required this.location});

  @override
  State<RentHomeSearchByLocation> createState() =>
      _RentHomeSearchByLocationState();
}

class _RentHomeSearchByLocationState extends State<RentHomeSearchByLocation> {
  late Future<List<dynamic>> motorcyclesByLocation;

  @override
  void initState() {
    super.initState();
    motorcyclesByLocation = fetchMotorcyclesByLocation(widget.location);
  }

  Future<List<dynamic>> fetchMotorcyclesByLocation(String district) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Tìm kiếm theo quận
      final districtSnapshot = await firestore
          .collection('motorcycles')
          .where('address.district', isEqualTo: district)
          .get();

      var motorcycles = districtSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();

      // Nếu không có kết quả, tìm kiếm theo thành phố
      if (motorcycles.isEmpty) {
        final citySnapshot = await firestore
            .collection('motorcycles')
            .where('address.city', isEqualTo: district)
            .get();

        motorcycles = citySnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();
      }

      return motorcycles;
    } catch (e) {
      throw Exception("Error fetching motorcycles by location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xe tại ${widget.location}"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: motorcyclesByLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(
                  child: Text('Không có xe nào tại địa điểm này.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var motorcycle = data[index];
                var info = motorcycle['informationMoto'] ?? {};
                var address = motorcycle['address'] ?? {};

                return InkWell(
                  onTap: () async {
                    // Điều hướng đến DetailMotoScreen và chờ kết quả trả về
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMotoScreen(
                          motorcycle: motorcycle, // Truyền motorcycle vào
                        ),
                      ),
                    );

                    // Nếu kết quả không null và chứa dữ liệu mong đợi
                    if (result != null &&
                        result['motorcycleId'] == motorcycle['id']) {
                      setState(() {
                        // Cập nhật trạng thái yêu thích dựa trên kết quả từ DetailMotoScreen
                        // Ví dụ nếu bạn cần cập nhật trạng thái yêu thích
                        motorcycle['isFavorite'] = result['isFavorite'];
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 0.2,
                        color: Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 0.2,
                                color: Colors.black,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (info['images'] != null &&
                                      info['images'].isNotEmpty)
                                  ? Image.network(
                                      info['images'][0],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/xe1.jpg",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(129, 255, 173, 21),
                            ),
                            child: Text(
                              "${motorcycle['category']?['name'] ?? 'Unknown'}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              info['nameMoto'] ?? "Automatic moto",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 5),
                              Text(
                                  "${address['district']}, ${address['city']}"),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 1),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 30,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "5.0",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 100),
                                    Row(
                                      children: [
                                        Icon(Icons.motorcycle),
                                        SizedBox(width: 5),
                                        Text(
                                          "10 chuyến",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        NumberFormat("#,###", "vi_VN")
                                            .format(info['price'] ?? 0),
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 253, 101, 20),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25,
                                        ),
                                      ),
                                      const Text(
                                        "đ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "/ngày",
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 83, 83, 83),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
    );
  }
}
