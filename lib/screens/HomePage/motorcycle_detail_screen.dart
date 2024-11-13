import 'package:flutter/material.dart';

class MotorcycleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> motorcycle;

  const MotorcycleDetailScreen({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context) {
    var info = motorcycle['informationMoto'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(info['nameMoto'] ?? 'Motorcycle Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            info['imagesMoto'] != null && info['imagesMoto'].isNotEmpty
                ? Image.network(info['imagesMoto'][0], fit: BoxFit.cover):
            const SizedBox(height: 10),
            Text(
              info['nameMoto'] ?? "Motorcycle",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: ${info['price'] ?? "111.000"} /day",
              style: const TextStyle(
                color: Color.fromARGB(255, 253, 101, 20),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              info['description'] ?? "No description available.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Energy: ${info['energy'] ?? "Unknown"}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Vehicle Mass: ${info['vehicleMass'] ?? "Unknown"} kg",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Number Plate: ${motorcycle['numberPlate'] ?? 'Unknown'}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Company: ${motorcycle['companyMoto']?['name'] ?? 'Unknown'}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Category: ${motorcycle['category']?['name'] ?? 'Unknown'}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
