// ignore_for_file: library_private_types_in_public_api

import 'package:final_project_rent_moto_fe/services/MotorCycle/update_motorcycle_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMotorcycleScreen extends StatefulWidget {
  final String id; // The ID of the motorcycle to update

  const UpdateMotorcycleScreen({super.key, required this.id});

  @override
  _UpdateMotorcycleScreenState createState() => _UpdateMotorcycleScreenState();
}

class _UpdateMotorcycleScreenState extends State<UpdateMotorcycleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController numberPlateController = TextEditingController();
  final TextEditingController nameMotoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController energyController = TextEditingController();
  final TextEditingController vehicleMassController = TextEditingController();

  String? selectedCompanyMoto;
  String? selectedCategory;
  List<String> companyMotoList = [];
  List<String> categoryList = [];
  List<XFile>? imagesMoto = [];

  bool isHide = false;
  bool isActive = true;

  final UpdateMotorcycleService updateMotorcycleService =
      UpdateMotorcycleService();
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchCompanyMotos();
    fetchCategories();
    fetchMotorcycleDetails(); // Fetch existing motorcycle details
  }

  Future<void> fetchCompanyMotos() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('companyMotos').get();
      setState(() {
        companyMotoList =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (error) {
      print("Error fetching company motos: $error");
    }
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categoryMotos').get();
      setState(() {
        categoryList =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (error) {
      print("Error fetching categories: $error");
    }
  }

  Future<void> fetchMotorcycleDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('motorcycles')
          .doc(widget.id)
          .get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          numberPlateController.text = data['numberPlate'];
          selectedCompanyMoto = data['companyMoto']['name'];
          selectedCategory = data['category']['name'];
          nameMotoController.text = data['informationMoto']['nameMoto'];
          priceController.text = data['informationMoto']['price'].toString();
          descriptionController.text = data['informationMoto']['description'];
          energyController.text = data['informationMoto']['energy'];
          vehicleMassController.text =
              data['informationMoto']['vehicleMass'].toString();

          isHide = data['isHide'] ?? false;
          isActive = data['isActive'] ?? true;
        });
      }
    } catch (error) {
      print("Error fetching motorcycle details: $error");
    }
  }

  void _submitUpdateForm() async {
    if (_formKey.currentState!.validate()) {
      final String numberPlate = numberPlateController.text;
      final String companyMotoName = selectedCompanyMoto!;
      final String categoryName = selectedCategory!;
      final String nameMoto = nameMotoController.text;
      final double price = double.tryParse(priceController.text) ?? 0.0;
      final String description = descriptionController.text;
      final String energy = energyController.text;
      final double vehicleMass =
          double.tryParse(vehicleMassController.text) ?? 0.0;

      List<String> imageUrls = [];

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('motorcycles')
          .doc(widget.id)
          .get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        imageUrls = List<String>.from(data['images'] ?? []);
      }

      try {
        bool success = await updateMotorcycleService.updateMotorcycle(
          id: widget.id,
          numberPlate: numberPlate,
          companyMotoName: companyMotoName,
          categoryName: categoryName,
          nameMoto: nameMoto,
          price: price,
          description: description,
          energy: energy,
          vehicleMass: vehicleMass,
          imagesMoto: imageUrls,
          isHide: isHide,
          isActive: isActive,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Motorcycle updated successfully!')),
          );
          Navigator.pop(context); // Go back after success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update motorcycle.')),
          );
        }
      } catch (error) {
        print("Error in updating motorcycle: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting update data.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Motorcycle'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number Plate Field with Icon
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: numberPlateController,
                    decoration: const InputDecoration(
                      labelText: 'Number Plate',
                      prefixIcon: Icon(Icons.card_travel),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a number plate' : null,
                  ),
                ),

                // Company Moto Dropdown
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    value: selectedCompanyMoto,
                    decoration: const InputDecoration(
                      labelText: 'Company Moto',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(),
                    ),
                    items: companyMotoList.map((company) {
                      return DropdownMenuItem<String>(
                        value: company,
                        child: Text(company),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCompanyMoto = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a company' : null,
                  ),
                ),

                // Category Dropdown
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: categoryList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                ),

                // Name Moto Field
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: nameMotoController,
                    decoration: const InputDecoration(
                      labelText: 'Name Moto',
                      prefixIcon: Icon(Icons.motorcycle),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                ),

                // Price Field
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixIcon: Icon(Icons.monetization_on),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a price' : null,
                  ),
                ),

                // Description Field
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                  ),
                ),

                // Energy Field
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: energyController,
                    decoration: const InputDecoration(
                      labelText: 'Energy',
                      prefixIcon: Icon(Icons.energy_savings_leaf),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter energy' : null,
                  ),
                ),

                // Vehicle Mass Field
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: vehicleMassController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Mass',
                      prefixIcon: Icon(Icons.fitness_center),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter vehicle mass' : null,
                  ),
                ),

                // Switch for Hiding Motorcycle
                SwitchListTile(
                  title: const Text('Hide Motorcycle'),
                  value: isHide,
                  onChanged: (value) {
                    setState(() {
                      isHide = value;
                    });
                  },
                  activeColor: Colors.teal,
                ),

                // Switch for Activating Motorcycle
                SwitchListTile(
                  title: const Text('Activate Motorcycle'),
                  value: isActive,
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                  },
                  activeColor: Colors.teal,
                ),

                const SizedBox(height: 20),

                // Update Motorcycle Button with Loading Indicator
                Center(
                  child: ElevatedButton(
                    onPressed: _submitUpdateForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16), // Padding around the text
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      elevation: 4, // Shadow effect for depth
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 18, // Larger font size for visibility
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
