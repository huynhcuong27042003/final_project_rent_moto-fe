import 'package:flutter/material.dart';

class DetailMotoInformation extends StatelessWidget {
  final Map<String, dynamic> motorcycle;

  const DetailMotoInformation({super.key, required this.motorcycle});

  @override
  Widget build(BuildContext context) {
    var info = motorcycle['informationMoto'] ?? {};

    return Column(
      children: [
        // Image section with dynamic image loading
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              info['images'] != null && info['images'].isNotEmpty
                  ? info['images'][0] // Use the first image if available
                  : '', // If no image, use an empty string
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Motorcycle Name (dynamic)
                    Text(
                      info['nameMoto'] ?? 'Motorcycle Name',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        // Dynamic price
                        Text(
                          '${info['price'] ?? "0"} / day',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star,
                      color: Colors.yellow), // Star icon for rating
                  const SizedBox(width: 2),
                  const Text(
                    '5.0', // Rating score
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/fast-delivery.png', // Delivery icon
                    width: 24,
                    height: 24,
                  ),
                  const Text(
                    '10 trip', // Number of trips
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Đặc điểm', // Features
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Motorcycle Features
              Container(
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 236, 237, 236).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Color Feature
                    Row(
                      children: [
                        const Icon(Icons.color_lens,
                            color: Color.fromARGB(
                                255, 255, 173, 21)), // Color icon
                        const SizedBox(width: 8),
                        Text(
                          "Vehicle Mass: ${info['vehicleMass'] ?? "Unknown"} cc",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    // Fuel consumption
                    Row(
                      children: [
                        Icon(Icons.local_gas_station,
                            color:
                                Color.fromARGB(255, 255, 173, 21)), // Fuel icon
                        SizedBox(width: 8),
                        Text(
                          "Energy: ${info['energy'] ?? "Unknown"}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Description (dynamic)
              Text(
                info['description'] ?? 'No description available.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
