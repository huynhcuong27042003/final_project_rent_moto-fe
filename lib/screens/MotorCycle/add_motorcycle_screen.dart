// // ignore_for_file: library_private_types_in_public_api
// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_nullable_for_final_variable_declarations
import 'dart:io';
import 'package:final_project_rent_moto_fe/services/MotorCycle/image_picker_addform_service.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/update_motorcycle_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/add_motorcycle_service.dart';
import 'package:image_picker/image_picker.dart';

class AddMotorcycleScreen extends StatefulWidget {
  const AddMotorcycleScreen({super.key});

  @override
  _AddMotorcycleScreenState createState() => _AddMotorcycleScreenState();
}

class _AddMotorcycleScreenState extends State<AddMotorcycleScreen> {
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

  final AddMotorcycleService addMotorcycleService = AddMotorcycleService();
  final UpdateMotorcycleService updateMotorcycleService =
      UpdateMotorcycleService();
  final ImagePickerAddformService imagePickerAddformService =
      ImagePickerAddformService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    companyMotoList = await updateMotorcycleService.fetchCompanyMotos();
    categoryList = await updateMotorcycleService.fetchCategories();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> pickImages() async {
    final selectedImages = await imagePickerAddformService.pickImages();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imagesMoto = selectedImages;
      });
    }
  }

  Future<List<String>> uploadImagesToFirebase(List<XFile> images) async {
    return await imagePickerAddformService.uploadImagesToFirebase(images);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String email = currentUser?.email ?? '';

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is required to submit form.')),
        );
        return;
      }

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

      // Check if email is missing
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is required to submit form.')),
        );
        return;
      }

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
          email: email, // Pass email to addMotorcycle
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
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser?.email ?? '';
    // Corrected access to email here
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
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(
                    labelText: 'Owner Email',
                    labelStyle: TextStyle(
                      color: Colors.teal, // Change the label text color
                      fontWeight: FontWeight.bold, // Make the label bold
                    ),
                    hintText: 'Email will be displayed here',
                    hintStyle: TextStyle(
                        color:
                            Colors.grey), // Hint style for better readability
                    filled: true, // Add a background color to the field
                    fillColor: Colors.grey[200], // Light grey background
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal,
                          width: 1.5), // Border color when not focused
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal,
                          width: 2), // Border color when focused
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 16, // Adjust font size for better readability
                  ),
                  readOnly:
                      true, // Make the field read-only so users cannot edit the email
                ),

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
                        DropdownButtonFormField<String>(
                          value: selectedCompanyMoto,
                          decoration:
                              const InputDecoration(labelText: 'Company Name'),
                          items: companyMotoList.isEmpty
                              ? [
                                  const DropdownMenuItem(
                                      child: Text("No companies available"))
                                ]
                              : companyMotoList
                                  .map((String company) =>
                                      DropdownMenuItem<String>(
                                          value: company, child: Text(company)))
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCompanyMoto = value;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Please select a company name'
                              : null,
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration:
                              const InputDecoration(labelText: 'Category Name'),
                          items: categoryList.isEmpty
                              ? [
                                  const DropdownMenuItem(
                                      child: Text("No categories available"))
                                ]
                              : categoryList
                                  .map((String category) =>
                                      DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(category)))
                                  .toList(),
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
