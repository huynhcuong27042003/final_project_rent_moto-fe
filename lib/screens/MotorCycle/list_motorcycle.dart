// // ignore_for_file: library_private_types_in_public_api

// ignore_for_file: library_private_types_in_public_api

import 'package:final_project_rent_moto_fe/screens/MotorCycle/update_motorcycle_screen.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/fetch_motorcycle_service.dart';
import 'package:flutter/material.dart';

class MotorcycleListScreen extends StatefulWidget {
  const MotorcycleListScreen({super.key});

  @override
  _MotorcycleListScreenState createState() => _MotorcycleListScreenState();
}

class _MotorcycleListScreenState extends State<MotorcycleListScreen> {
  final FetchMotorcycleService _fetchMotorcycleService =
      FetchMotorcycleService();
  List<Map<String, dynamic>> motorcycles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMotorcycles();
  }

  // Trong lớp _MotorcycleListScreenState
  void _navigateToUpdateScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateMotorcycleScreen(id: id),
      ),
    );
  }

  void loadMotorcycles() async {
    motorcycles = await _fetchMotorcycleService.fetchMotorcycles();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motorcycle List'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: motorcycles.length,
              itemBuilder: (context, index) {
                final motorcycle = motorcycles[index];
                final id = motorcycle['id']; // Get the id from Firestore
                final nameMoto =
                    motorcycle['informationMoto']['nameMoto'] ?? 'Unknown Name';
                final numberPlate = motorcycle['numberPlate'] ?? 'No Plate';
                final price = motorcycle['informationMoto']['price'] ?? 'N/A';
                final imageUrl = motorcycle['images']?.isNotEmpty == true
                    ? motorcycle['images'][0]
                    : 'https://example.com/default_image.jpg'; // Placeholder image URL

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      numberPlate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameMoto,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: \$${price}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        // Do nothing when the red "X" icon is tapped
                      },
                      child: const Icon(
                        Icons.close, // Red "X" icon
                        color: Colors.red, // Set color to red
                      ),
                    ),
                    onTap: () => _navigateToUpdateScreen(
                        id), // Navigate to the update screen
                  ),
                );
              },
            ),
    );
  }
}
