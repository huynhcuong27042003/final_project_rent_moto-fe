// ignore_for_file: avoid_print

import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:final_project_rent_moto_fe/screens/detail/detail_moto_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/fetch_motorcycle_isaccept_service.dart';
import 'package:final_project_rent_moto_fe/app_icons_icons.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
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
  late String userEmail; // Store the user's email
  Map<String, bool> motorcycleFavoriteState = {};

  @override
  void initState() {
    super.initState();
    motorcycles = motorcycleService.fetchMotorcycle();
    _loadUserFavoriteState(); // Load the user's favorite state when the widget is initialized
  }

  Future<void> _loadUserFavoriteState() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userEmail = currentUser.email ?? 'No email available';

      try {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã thêm vào danh sách yêu thích!")),
        );
      } else {
        // Remove motorcycle from favorite list
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
            future: motorcycles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                var data = snapshot.data!;
                if (data.isEmpty) {
                  return const Center(child: Text('No motorcycles found'));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: data.map((motorcycle) {
                      var info = motorcycle['informationMoto'] ?? {};
                      var address = motorcycle['address'] ?? {};
                      String motorcycleId = motorcycle['id'] ?? '';
                      bool isFavorite =
                          motorcycleFavoriteState[motorcycleId] ?? false;

                      return InkWell(
                        onTap: () async {
                          // Wait for the result from DetailMotoScreen
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMotoScreen(
                                motorcycle: motorcycle,
                              ),
                            ),
                          );

                          // Check if result is not null and the motorcycleId matches
                          if (result != null &&
                              result['motorcycleId'] == motorcycleId) {
                            setState(() {
                              // Update the favorite state based on the result
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
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
                                    Icon(Icons.location_on),
                                    SizedBox(width: 5),
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
                                      Row(
                                        children: const [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "5.0",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 100),
                                          Row(
                                            children: [
                                              Icon(AppIcons.suitcase),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "10 chuyến",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                              )
                                            ],
                                          )
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
                                            Text(
                                              "đ",
                                              style: const TextStyle(
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
                return const Center(
                  child: Text('Không có dữ liệu'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
