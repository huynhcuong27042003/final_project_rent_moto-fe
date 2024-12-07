import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase
import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:final_project_rent_moto_fe/screens/detail/detail_moto_screen.dart';
import 'package:final_project_rent_moto_fe/services/promoByCompany/applyPromoByCompany.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/fetch_motorcycle_isaccept_service.dart';
import 'package:final_project_rent_moto_fe/app_icons_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/get_favoritelist_service.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/add_favoritelist_service.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/delete_favoritelist_service.dart';
import 'package:intl/intl.dart';

class RentHomeInforMotos extends StatefulWidget {
  const RentHomeInforMotos({super.key});

  @override
  State<RentHomeInforMotos> createState() => _RentHomeInforMotosState();
}

class _RentHomeInforMotosState extends State<RentHomeInforMotos> {
  late Future<List<dynamic>> motorcycles;
  final FetchMotorcycleIsacceptService motorcycleService =
      FetchMotorcycleIsacceptService();
  late String userEmail;
  Map<String, bool> motorcycleFavoriteState = {};
  late Future<List<Map<String, dynamic>>> promotedMotorcyclesFuture;
  final ApplyPromoByCompanyService applyPromoService =
      ApplyPromoByCompanyService(); // Sử dụng service mới

  @override
  void initState() {
    super.initState();
    motorcycles = motorcycleService.fetchMotorcycle();
    promotedMotorcyclesFuture = applyPromoService
        .getPromotedMotorcycles(); // Sử dụng service mới để lấy khuyến mãi
    _loadUserFavoriteState();
  }

  // Load the user's favorite state
  Future<void> _loadUserFavoriteState() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userEmail = currentUser.email ?? 'No email available';

      try {
        // Get the user's favorite motorcycles
        List<String> favoriteMotorcycles = await getFavoriteList(userEmail);

        setState(() {
          // Mark each motorcycle as favorite if it's in the favorite list
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

  // Toggle the favorite state for a motorcycle
  Future<void> toggleFavorite(String motorcycleId) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const Dashboard(initialIndex: 2), // Chỉ số UserInforScreen
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
        // Add motorcycle to favorite list
        await addFavoriteList(email, [motorcycleId]);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã thêm vào danh sách yêu thích!")),
        );
      } else {
        // Remove motorcycle from favorite list
        await deleteFavoriteListService(email, motorcycleId);
        // ignore: use_build_context_synchronously
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Xe máy danh cho bạn",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          FutureBuilder<List<dynamic>>(
            future: Future.wait([motorcycles, promotedMotorcyclesFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                var motorcyclesData = snapshot.data![0] as List<dynamic>;
                var promotedMotorcyclesData =
                    snapshot.data![1] as List<dynamic>;

                Set<String> promotedNumberPlates = promotedMotorcyclesData
                    .map((moto) => moto['numberPlate'] as String?)
                    .where((plate) => plate != null)
                    .cast<String>()
                    .toSet();

                List<dynamic> motorcyclesWithoutPromotion =
                    motorcyclesData.where((motorcycle) {
                  return !promotedNumberPlates
                      .contains(motorcycle['numberPlate']);
                }).toList();

                List<dynamic> allMotorcycles = [
                  ...promotedMotorcyclesData,
                  ...motorcyclesWithoutPromotion,
                ];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: allMotorcycles.map((motorcycle) {
                      var info = motorcycle['informationMoto'] ?? {};
                      var address = motorcycle['address'] ?? {};
                      String motorcycleId = motorcycle['id'] ?? '';
                      bool isFavorite =
                          motorcycleFavoriteState[motorcycleId] ?? false;

                      double originalPrice = (info['price'] ?? 0.0).toDouble();
                      double discountedPrice = originalPrice;

                      if (motorcycle['promotion'] != null) {
                        double discountPercentage =
                            (motorcycle['promotion']['percentage'] ?? 0.0)
                                .toDouble();
                        discountedPrice = originalPrice -
                            (originalPrice * discountPercentage / 100);
                      }

                      return InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMotoScreen(
                                motorcycle: motorcycle,
                              ),
                            ),
                          );

                          if (result != null &&
                              result['motorcycleId'] == motorcycleId) {
                            setState(() {
                              motorcycleFavoriteState[motorcycleId] =
                                  result['isFavorite'];
                            });
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 0.2, color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 0.2, color: Colors.black),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: (info['images'] != null &&
                                                info['images'].isNotEmpty)
                                            ? Image.network(info['images'][0],
                                                fit: BoxFit.cover)
                                            : Image.asset(
                                                "assets/images/xe1.jpg",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      if (motorcycle['promotion'] != null)
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'Giảm ${motorcycle['promotion']['percentage']}%',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
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
                                        "${address['district']}, ${address['city']}"),
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
                                      const Row(
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
                                      Row(
                                        children: [
                                          // Hiển thị giá gốc với gạch ngang
                                          if (motorcycle['promotion'] != null)
                                            Text(
                                              NumberFormat("#,###", "vi_VN")
                                                  .format(originalPrice),
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 20,
                                                color: Colors.grey,
                                              ),
                                            ),

                                          // Hiển thị giá đã giảm hoặc giá gốc
                                          Text(
                                            NumberFormat("#,###", "vi_VN")
                                                .format(discountedPrice),
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 253, 101, 20),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 25,
                                            ),
                                          ),
                                          const Text(
                                            " đ/ngày",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          )
        ],
      ),
    );
  }
}
