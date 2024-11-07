// // ignore_for_file: library_private_types_in_public_api
// import 'dart:io';
// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_nullable_for_final_variable_declarations

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/add_motorcycle_service.dart';
import 'package:image_picker/image_picker.dart';

class MotorcycleForm extends StatefulWidget {
  const MotorcycleForm({super.key});

  @override
  _MotorcycleFormState createState() => _MotorcycleFormState();
}

class _MotorcycleFormState extends State<MotorcycleForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
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

  final AddMotorcycleService addMotorcycleService = AddMotorcycleService();
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchCompanyMotos();
    fetchCategories();
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

  Future<void> pickImages() async {
    try {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          imagesMoto = selectedImages;
        });
      }
    } catch (error) {
      print("Error picking images: $error");
    }
  }

  Future<List<String>> uploadImagesToFirebase(List<XFile> images) async {
    List<String> downloadUrls = [];

    for (var image in images) {
      try {
        File file = File(image.path);
        print("Uploading image from path: ${image.path}");

        // Generate a unique file name with a timestamp
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference ref =
            FirebaseStorage.instance.ref().child('motorcycle_images/$fileName');

        // Upload the file to Firebase Storage
        await ref.putFile(file);

        // Retrieve and store the download URL
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
        print("Uploaded image URL: $downloadUrl");
      } catch (error) {
        print("Error uploading image: $error");
      }
    }

    return downloadUrls;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Get values from the form
      final String numberPlate = numberPlateController.text;
      final String companyMotoName = selectedCompanyMoto!;
      final String categoryName = selectedCategory!;
      final String nameMoto = nameMotoController.text;
      final double price = double.tryParse(priceController.text) ?? 0.0;
      final String description = descriptionController.text;
      final String energy = energyController.text;
      final double vehicleMass =
          double.tryParse(vehicleMassController.text) ?? 0.0;

      // Upload images and obtain their URLs
      List<String> imageUrls = await uploadImagesToFirebase(imagesMoto!);
      print("Uploaded image URLs: $imageUrls");

      // Try adding the motorcycle using the service
      try {
        bool success = await addMotorcycleService.addMotorcycle(
          numberPlate: numberPlate,
          companyMotoName: companyMotoName,
          categoryName: categoryName,
          nameMoto: nameMoto,
          price: price,
          description: description,
          energy: energy,
          vehicleMass: vehicleMass,
          imagesMoto: imageUrls,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Motorcycle added successfully!')),
          );
          _formKey.currentState!.reset();
          setState(() {
            imagesMoto = [];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add motorcycle.')),
          );
        }
      } catch (error) {
        print("Error in submitting form: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting motorcycle data.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Motorcycle'),
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
                // Motorcycle Details Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Information vehicle",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const Divider(),
                        // Number Plate
                        TextFormField(
                          controller: numberPlateController,
                          decoration:
                              const InputDecoration(labelText: 'Number Plate'),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a number plate'
                              : null,
                        ),
                        // Company Name
                        DropdownButtonFormField<String>(
                          value: selectedCompanyMoto,
                          decoration:
                              const InputDecoration(labelText: 'Company Name'),
                          items: companyMotoList.isEmpty
                              ? [
                                  const DropdownMenuItem(
                                      child: Text("No companies available"))
                                ]
                              : companyMotoList.map((String company) {
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
                          validator: (value) => value == null
                              ? 'Please select a company name'
                              : null,
                        ),
                        // Category Name
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration:
                              const InputDecoration(labelText: 'Category Name'),
                          items: categoryList.isEmpty
                              ? [
                                  const DropdownMenuItem(
                                      child: Text("No categories available"))
                                ]
                              : categoryList.map((String category) {
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
                        // Motorcycle Name
                        TextFormField(
                          controller: nameMotoController,
                          decoration: const InputDecoration(
                              labelText: 'Motorcycle Name'),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a motorcycle name'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pricing and Specifications Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pricing & Specifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const Divider(),
                        // Price
                        TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter a price';
                            if (double.tryParse(value) == null)
                              return 'Please enter a valid number';
                            return null;
                          },
                        ),
                        // Description
                        TextFormField(
                          controller: descriptionController,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a description'
                              : null,
                        ),
                        // Energy Type
                        TextFormField(
                          controller: energyController,
                          decoration:
                              const InputDecoration(labelText: 'Energy Type'),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter energy type'
                              : null,
                        ),
                        // Vehicle Mass
                        TextFormField(
                          controller: vehicleMassController,
                          decoration:
                              const InputDecoration(labelText: 'Vehicle Mass'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Please enter vehicle mass';
                            if (double.tryParse(value) == null)
                              return 'Please enter a valid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Image Picker Section
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Center-aligns children horizontally
                    children: [
                      const Text(
                        "Upload Images",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const Divider(),
                      ElevatedButton.icon(
                        onPressed: pickImages,
                        icon: const Icon(Icons.photo_library),
                        label: const Text(
                          'Pick Images',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      imagesMoto!.isEmpty
                          ? const Text('No images selected.')
                          : SizedBox(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: imagesMoto!.map((image) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(image.path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                      const SizedBox(height: 20),

                      // Submit Button
                      ElevatedButton(
                        onPressed: _submitForm,
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
                          'Submit',
                          style: TextStyle(
                            fontSize: 18, // Larger font size for visibility
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
