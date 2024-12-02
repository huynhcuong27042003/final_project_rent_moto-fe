import 'package:final_project_rent_moto_fe/app_icons_icons.dart';
import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:final_project_rent_moto_fe/screens/detail/detail_moto_screen.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/fetch_motorcycle_isaccept_service.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/add_favoritelist_service.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/delete_favoritelist_service.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/get_favoritelist_service.dart';
import 'package:final_project_rent_moto_fe/services/map/map_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class SearchMotoScreen extends StatefulWidget {
  final String location;
  final String time;
  const SearchMotoScreen({
    super.key,
    required this.location,
    required this.time,
  });

  @override
  State<SearchMotoScreen> createState() => _SearchMotoScreenState();
}

class _SearchMotoScreenState extends State<SearchMotoScreen> {
  late Future<List<dynamic>> motorcycles;
  final FetchMotorcycleIsacceptService motorcycleService =
      FetchMotorcycleIsacceptService();
  late String userEmail; // Store the user's email
  Map<String, bool> motorcycleFavoriteState = {};
  late LatLng userLocation;
  bool isLoading = true; // Dùng để kiểm tra trạng thái tải dữ liệu
  Map<String, double> distances = {};
  List<dynamic> sortedMotorcycles = [];
  @override
  void initState() {
    super.initState();
    motorcycles = motorcycleService.fetchMotorcycle();
    _loadUserFavoriteState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      MapService mapService = MapService();
      userLocation = await mapService.getCoordinates(widget.location);
      await _calculateDistances(); // Tính toán khoảng cách sau khi lấy tọa độ
    } catch (e) {
      print("Failed to get user location: $e");
    }
  }

  Future<void> _calculateDistances() async {
    final distanceCalculator = Distance();
    motorcycles.then((motorcycleList) async {
      List<dynamic> updatedMotorcycles = motorcycleList;
      for (var motorcycle in motorcycleList) {
        var address = motorcycle['address'] ?? {};
        String fullAddress =
            "${address['streetName'] ?? ''} ${address['district'] ?? ''}, ${address['city'] ?? ''}";

        try {
          MapService mapService = MapService();
          LatLng motoLocation = await mapService.getCoordinates(fullAddress);

          double distanceInMeters = distanceCalculator.as(
              LengthUnit.Meter, userLocation, motoLocation);

          setState(() {
            distances[motorcycle['id'] ?? ''] = distanceInMeters / 1000; // km
          });
        } catch (e) {
          print("Error calculating distance for motorcycle: $e");
        }
      }

      // Sau khi tính toán khoảng cách, sắp xếp danh sách xe máy theo khoảng cách từ nhỏ đến lớn
      updatedMotorcycles.sort((a, b) {
        double distanceA = distances[a['id']] ?? double.infinity;
        double distanceB = distances[b['id']] ?? double.infinity;
        return distanceA.compareTo(distanceB);
      });

      setState(() {
        sortedMotorcycles = updatedMotorcycles; // Lưu lại danh sách đã sắp xếp
        isLoading = false; // Đặt trạng thái tải xong
      });
    });
  }

  Future<void> _loadUserFavoriteState() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userEmail = currentUser.email ?? 'No email available';

      try {
        List<String> favoriteMotorcycles = await getFavoriteList(userEmail);

        setState(() {
          motorcycles.then((motorcycleList) {
            for (var motorcycle in motorcycleList) {
              String motorcycleId = motorcycle['id'] ?? '';
              motorcycleFavoriteState[motorcycleId] =
                  favoriteMotorcycles.contains(motorcycleId);
            }
          });
        });
      } catch (e) {
        print("Failed to load favorite state: $e");
      }
    }
  }

  Future<void> toggleFavorite(String motorcycleId) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(initialIndex: 2),
          ),
        );
      }
      return;
    }
    final String email = currentUser?.email ?? 'No email available';

    try {
      setState(() {
        motorcycleFavoriteState[motorcycleId] =
            !motorcycleFavoriteState[motorcycleId]!;
      });

      if (motorcycleFavoriteState[motorcycleId]!) {
        await addFavoriteList(email, [motorcycleId]);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã thêm vào danh sách yêu thích!")),
        );
      } else {
        await deleteFavoriteListService(email, motorcycleId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã xóa khỏi danh sách yêu thích!")),
        );
      }
    } catch (error) {
      setState(() {
        motorcycleFavoriteState[motorcycleId] =
            !motorcycleFavoriteState[motorcycleId]!;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update favorite list: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách xe"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: motorcycles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(child: Text('Không có xe nào được tìm thấy'));
            }

            return isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var motorcycle = data[index];
                      var info = motorcycle['informationMoto'] ?? {};
                      var address = motorcycle['address'] ?? {};
                      String motorcycleId = motorcycle['id'] ?? '';
                      bool isFavorite =
                          motorcycleFavoriteState[motorcycleId] ?? false;

                      return InkWell(
                        onTap: () async {
                          // Chờ kết quả từ DetailMotoScreen
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMotoScreen(
                                motorcycle: motorcycle,
                              ),
                            ),
                          );

                          // Kiểm tra nếu có kết quả trả về và khớp với motorcycleId
                          if (result != null &&
                              result['motorcycleId'] == motorcycleId) {
                            setState(() {
                              // Cập nhật trạng thái yêu thích
                              motorcycleFavoriteState[motorcycleId] =
                                  result['isFavorite'];
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
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
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset(
                                            "assets/images/xe1.jpg",
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color.fromARGB(
                                            129, 255, 173, 21),
                                      ),
                                      child: Text(
                                        "${motorcycle['category']?['name'] ?? 'Unknown'}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.black,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        toggleFavorite(motorcycleId);
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
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
                                        "${address['district'] ?? ''}, ${address['city'] ?? ''}"),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.route,
                                      color: Colors.blue,
                                    ),
                                    distances.containsKey(motorcycleId)
                                        ? Text(
                                            "~${distances[motorcycleId]?.toStringAsFixed(1)} km",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          )
                                        : const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                              Icon(AppIcons.suitcase),
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              NumberFormat("#,###", "vi_VN")
                                                  .format(info['price'] ?? 0),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 253, 101, 20),
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
                                                  color: Color.fromARGB(
                                                      255, 83, 83, 83),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          } else {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }
        },
      ),
    );
  }
}
