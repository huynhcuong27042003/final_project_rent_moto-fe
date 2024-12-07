// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_rent_moto_fe/screens/dashboard.dart';
import 'package:final_project_rent_moto_fe/screens/detail/detail_moto_screen.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/add_favoritelist_service.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/delete_favoritelist_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project_rent_moto_fe/services/favorite_list/get_favorite_list_by_user.dart';

class ListFavoriteByUser extends StatefulWidget {
  const ListFavoriteByUser({super.key});

  @override
  State<ListFavoriteByUser> createState() => _ListFavoriteByUserState();
}

class _ListFavoriteByUserState extends State<ListFavoriteByUser> {
  Future<List<Map<String, dynamic>>>? favoriteList;
  Map<String, bool> motorcycleFavoriteState =
      {}; // To track favorite state for each motorcycle

  @override
  void initState() {
    super.initState();
    fetchFavoriteList();
  }

  Future<void> fetchFavoriteList() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String email = currentUser?.email ?? '';

      if (email.isNotEmpty) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          String firestoreUserId = userDoc.id;

          List<Map<String, dynamic>> data =
              await getFavoriteListByUserService(firestoreUserId);
          setState(() {
            favoriteList = Future.value(data);

            motorcycleFavoriteState = {
              for (var motorcycle in data) motorcycle['id']: true
            };
          });
        } else {
          throw Exception("User document not found in Firestore.");
        }
      } else {
        throw Exception("User email not available.");
      }
    } catch (error) {
      print("Error fetching Firestore user ID: $error");
    }
  }

  Future<void> toggleFavorite(String motorcycleId) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser?.email ?? 'No email available';

    try {
      setState(() {
        motorcycleFavoriteState[motorcycleId] =
            !(motorcycleFavoriteState[motorcycleId] ?? false);
      });

      if (motorcycleFavoriteState[motorcycleId]!) {
        await addFavoriteList(email, [motorcycleId]);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Motorcycle added to favorites!")),
          );
        }
      } else {
        await deleteFavoriteListService(email, motorcycleId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Motorcycle removed from favorites!")),
          );
        }

        setState(() {
          favoriteList = favoriteList == null
              ? Future.value(
                  []) // Nếu favoriteList là null, trả về danh sách trống
              : favoriteList!.then((list) {
                  return list
                      .where((motorcycle) => motorcycle['id'] != motorcycleId)
                      .toList();
                });
        });
      }
    } catch (error) {
      // Nếu có lỗi, khôi phục lại trạng thái trước đó
      setState(() {
        motorcycleFavoriteState[motorcycleId] =
            !(motorcycleFavoriteState[motorcycleId] ?? false);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update favorite list: $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          },
        ),
        title: const Text(
          'Danh sách xe yêu thích',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: favoriteList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      var data = snapshot.data!;
                      if (data.isEmpty) {
                        return const Center(child: Text('No favorites found'));
                      }

                      return Column(
                        children: data.map((motorcycle) {
                          var info = motorcycle['informationMoto'] ?? {};
                          String motorcycleId = motorcycle['id'] ?? '';
                          bool isFavorite =
                              motorcycleFavoriteState[motorcycleId] ?? false;

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
                                  // If the motorcycle was removed, update the list
                                  if (!result['isFavorite']) {
                                    favoriteList = favoriteList!.then((list) {
                                      return list
                                          .where((motorcycle) =>
                                              motorcycle['id'] != motorcycleId)
                                          .toList();
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              margin: const EdgeInsets.only(bottom: 20),
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
                                    // Motorcycle Image
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
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
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: const Color.fromARGB(
                                                129, 255, 173, 21),
                                          ),
                                          child: Text(
                                            "Category: ${motorcycle['category']?['name'] ?? 'Unknown'}",
                                            style:
                                                const TextStyle(fontSize: 12),
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
                                            toggleFavorite(
                                              motorcycleId,
                                            ); // Truyền 2 tham số
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
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
                                        Expanded(
                                          child: Text(
                                            "Address: ${motorcycle['address']?['streetName'] ?? 'Unknown'}, "
                                            "${motorcycle['address']?['district'] ?? 'Unknown'}, "
                                            "${motorcycle['address']?['city'] ?? 'Unknown'}, "
                                            "${motorcycle['address']?['country'] ?? 'Unknown'}",
                                            style:
                                                const TextStyle(fontSize: 16),
                                            overflow: TextOverflow
                                                .ellipsis, // Optionally, use this to show ellipsis for overflow
                                            softWrap:
                                                true, // Ensures the text will wrap onto the next line if necessary
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 100),
                                              Row(
                                                children: [
                                                  Icon(Icons.business_center),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "10 trips",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                  "${info['price'] ?? "111.000"}",
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 253, 101, 20),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    "VND/day",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
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
                      );
                    } else {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Căn giữa theo chiều dọc
                          children: [
                            // Biểu tượng tải hình tròn chuyển động
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 4, // Độ dày của vòng tải
                                color: Colors.blueAccent, // Màu của biểu tượng
                              ),
                            ),
                            SizedBox(
                                height:
                                    10), // Khoảng cách giữa biểu tượng và văn bản
                            // Văn bản hiển thị
                            Text(
                              "Đang tải...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
