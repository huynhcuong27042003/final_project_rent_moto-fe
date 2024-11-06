// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/screens/CategoryMoto/add_category_screen.dart';
import 'package:final_project_rent_moto_fe/screens/CategoryMoto/update_category_screen.dart';
import 'package:final_project_rent_moto_fe/services/CategoryMoto/fetch_category_service.dart';
import 'package:final_project_rent_moto_fe/services/CategoryMoto/update_category_service.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  _ListCategoryScreenState createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  final FetchCategoryService _fetchService = FetchCategoryService();
  final UpdateCategoryService _updateService = UpdateCategoryService();

  void _showUpdateDialog(Map<String, dynamic> moto) {
    final String? id = moto['id'] as String?;

    if (id == null) {
      // Handle the case where the ID is null
      print("Error: 'id' is null for moto: $moto");
      return; // Exit the function or show a message
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return UpdateCategoryScreen(
          id: moto['id'],
          currentName: moto['name'],
          currentIsHide: moto['isHide'],
          onUpdate: (id, name, isHide) async {
            try {
              await _updateService.updateCategoryMoto(id, name, isHide);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Updated category moto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            } catch (e) {
              // Handle error
            }
          },
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'List Category Motos',
  //         style: TextStyle(color: Colors.blue),
  //       ),
  //       centerTitle: true,
  //       backgroundColor: Colors.white,
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back, color: Colors.blue),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: StreamBuilder<List<Map<String, dynamic>>>(
  //         stream: _fetchService.fetchCategoryMotos(), // Get the Stream here
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const Center(child: CircularProgressIndicator());
  //           }
  //           if (snapshot.hasError) {
  //             return Center(child: Text('Error: ${snapshot.error}'));
  //           }
  //           if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //             return Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     'No category mottos available.',
  //                     style: TextStyle(fontSize: 18, color: Colors.grey[600]),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pushReplacement(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => const AddCategoryScreen()),
  //                       );
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       padding: const EdgeInsets.symmetric(
  //                           vertical: 12, horizontal: 24),
  //                       backgroundColor: Colors.white,
  //                       foregroundColor: Colors.blue,
  //                     ),
  //                     child: const Text(
  //                       'Add Category Moto',
  //                       style: TextStyle(fontSize: 16),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }

  //           // If data is available, display the list
  //           final categoryMotos = snapshot.data!;
  //           return ListView.builder(
  //             itemCount: categoryMotos.length,
  //             itemBuilder: (ctx, index) {
  //               final moto = categoryMotos[index];
  //               return Card(
  //                 margin: const EdgeInsets.symmetric(vertical: 6),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 elevation: 3,
  //                 child: ListTile(
  //                   contentPadding:
  //                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //                   title: Text(
  //                     moto['name'],
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16,
  //                     ),
  //                   ),
  //                   trailing: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       IconButton(
  //                         icon: const Icon(Icons.edit, color: Colors.blue),
  //                         onPressed: () => _showUpdateDialog(moto),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },

  //           );
  //         },

  //       ),

  //     ),

  //   );

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Category Motos',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream:
                    _fetchService.fetchCategoryMotos(), // Get the Stream here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No category mottos available.',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }

                  // If data is available, display the list
                  final categoryMotos = snapshot.data!;
                  return ListView.builder(
                    itemCount: categoryMotos.length,
                    itemBuilder: (ctx, index) {
                      final moto = categoryMotos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          title: Text(
                            moto['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showUpdateDialog(moto),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Add the button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCategoryScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
                child: const Text(
                  'Add Category Moto',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
