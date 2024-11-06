// // ignore_for_file: library_private_types_in_public_api

// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_rent_moto/services/MotorCycle/add_motorcycle_service.dart';
// import 'package:image_picker/image_picker.dart';

// class MotorcycleForm extends StatefulWidget {
//   const MotorcycleForm({super.key});

//   @override
//   _MotorcycleFormState createState() => _MotorcycleFormState();
// }

// class _MotorcycleFormState extends State<MotorcycleForm> {
//   final _formKey = GlobalKey<FormState>();

//   // Form field controllers
//   final TextEditingController numberPlateController = TextEditingController();
//   final TextEditingController nameMotoController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController energyController = TextEditingController();
//   final TextEditingController vehicleMassController = TextEditingController();

//   String? selectedCompanyMoto;
//   String? selectedCategory;
//   List<String> companyMotoList = [];
//   List<String> categoryList = [];
//   List<XFile>? imagesMoto = [];

//   final AddMotorcycleService addMotorcycleService = AddMotorcycleService();
//   final ImagePicker imagePicker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     fetchCompanyMotos();
//     fetchCategories();
//   }

//   Future<void> fetchCompanyMotos() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('companyMotos').get();
//       setState(() {
//         companyMotoList =
//             querySnapshot.docs.map((doc) => doc['name'] as String).toList();
//       });
//     } catch (error) {
//       print("Error fetching company motos: $error");
//     }
//   }

//   Future<void> fetchCategories() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('categoryMotos').get();
//       setState(() {
//         categoryList =
//             querySnapshot.docs.map((doc) => doc['name'] as String).toList();
//       });
//     } catch (error) {
//       print("Error fetching categories: $error");
//     }
//   }

//   Future<void> pickImages() async {
//     try {
//       final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
//       if (selectedImages != null) {
//         setState(() {
//           imagesMoto = selectedImages;
//         });
//       }
//     } catch (error) {
//       print("Error picking images: $error");
//     }
//   }

//   Future<List<String>> uploadImagesToFirebase(List<XFile> images) async {
//     List<String> downloadUrls = [];
//     for (var image in images) {
//       File file = File(image.path);
//       print("Image path: ${image.path}"); // In ra đường dẫn

//       // Kiểm tra xem tệp có tồn tại không
//       if (await file.exists()) {
//         try {
//           // Đặt tên tệp duy nhất bằng timestamp
//           String fileName =
//               DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
//           Reference ref = FirebaseStorage.instance
//               .ref()
//               .child('motorcycle_images/$fileName');

//           // Tải ảnh lên Firebase Storage
//           await ref.putFile(file);

//           // Lấy URL tải xuống
//           String downloadUrl = await ref.getDownloadURL();
//           downloadUrls.add(downloadUrl);
//         } catch (error) {
//           print("Error uploading image: $error"); // Ghi lại lỗi
//         }
//       } else {
//         print(
//             "File does not exist: ${file.path}"); // Thông báo tệp không tồn tại
//       }
//     }
//     return downloadUrls;
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final String numberPlate = numberPlateController.text;
//       final String companyMotoName = selectedCompanyMoto!;
//       final String categoryName = selectedCategory!;
//       final String nameMoto = nameMotoController.text;
//       final double price = double.tryParse(priceController.text) ?? 0.0;
//       final String description = descriptionController.text;
//       final String energy = energyController.text;
//       final double vehicleMass =
//           double.tryParse(vehicleMassController.text) ?? 0.0;

//       // Upload images to Firebase Storage and get URLs
//       List<String> imageUrls = await uploadImagesToFirebase(imagesMoto!);

//       // Call service to add motorcycle with URLs
//       bool success = await addMotorcycleService.addMotorcycle(
//         numberPlate: numberPlate,
//         companyMotoName: companyMotoName,
//         categoryName: categoryName,
//         nameMoto: nameMoto,
//         price: price,
//         description: description,
//         energy: energy,
//         vehicleMass: vehicleMass,
//         imagesMoto: imageUrls,
//       );

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Motorcycle added successfully!')),
//         );
//         _formKey.currentState!.reset();
//         setState(() {
//           imagesMoto = [];
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add motorcycle.')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Motorcycle')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: numberPlateController,
//                   decoration: InputDecoration(labelText: 'Number Plate'),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter a number plate' : null,
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: selectedCompanyMoto,
//                   decoration: InputDecoration(labelText: 'Company Name'),
//                   items: companyMotoList.isEmpty
//                       ? [
//                           DropdownMenuItem(
//                               child: Text("No companies available"))
//                         ]
//                       : companyMotoList.map((String company) {
//                           return DropdownMenuItem<String>(
//                             value: company,
//                             child: Text(company),
//                           );
//                         }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedCompanyMoto = value;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Please select a company name' : null,
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: selectedCategory,
//                   decoration: InputDecoration(labelText: 'Category Name'),
//                   items: categoryList.isEmpty
//                       ? [
//                           DropdownMenuItem(
//                               child: Text("No categories available"))
//                         ]
//                       : categoryList.map((String category) {
//                           return DropdownMenuItem<String>(
//                             value: category,
//                             child: Text(category),
//                           );
//                         }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedCategory = value;
//                     });
//                   },
//                   validator: (value) =>
//                       value == null ? 'Please select a category' : null,
//                 ),
//                 TextFormField(
//                   controller: nameMotoController,
//                   decoration: InputDecoration(labelText: 'Motorcycle Name'),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter a motorcycle name' : null,
//                 ),
//                 TextFormField(
//                   controller: priceController,
//                   decoration: InputDecoration(labelText: 'Price'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value!.isEmpty) return 'Please enter a price';
//                     if (double.tryParse(value) == null)
//                       return 'Please enter a valid number';
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: 'Description'),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter a description' : null,
//                 ),
//                 TextFormField(
//                   controller: energyController,
//                   decoration: InputDecoration(labelText: 'Energy Type'),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter energy type' : null,
//                 ),
//                 TextFormField(
//                   controller: vehicleMassController,
//                   decoration: InputDecoration(labelText: 'Vehicle Mass'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value!.isEmpty) return 'Please enter vehicle mass';
//                     if (double.tryParse(value) == null)
//                       return 'Please enter a valid number';
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: pickImages,
//                   child: Text('Pick Images'),
//                 ),
//                 SizedBox(height: 10),
//                 imagesMoto!.isEmpty
//                     ? Text('No images selected.')
//                     : Wrap(
//                         spacing: 8.0,
//                         children: imagesMoto!.map((image) {
//                           return Image.file(
//                             File(image.path),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           );
//                         }).toList(),
//                       ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:final_project_rent_moto_fe/services/MotorCycle/add_motorcycle_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MotorcycleForm extends StatefulWidget {
  @override
  _MotorcycleFormState createState() => _MotorcycleFormState();
}

class _MotorcycleFormState extends State<MotorcycleForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController numberPlateController = TextEditingController();
  final TextEditingController nameMotoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController energyController = TextEditingController();
  final TextEditingController vehicleMassController = TextEditingController();
  final String cloudName = 'dafylnj6r';
  final String apiKey = '121321274827681';
  final String apiSecret = 'ZYR82DmC8XXVlpdU0EWPvzaJ6Es';
  final AddMotorcycleService addMotorcycleService = AddMotorcycleService();

  String? selectedCompanyMoto;
  String? selectedCategory;
  List<String> companyMotoList = [];
  List<String> categoryList = [];

  List<XFile>? imagesMoto = [];
  final ImagePicker imagePicker = ImagePicker();
  String? accessToken;

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

  bool _isPicking = false;

  Future<void> pickImages() async {
    if (_isPicking)
      return; // Không cho phép chọn hình ảnh nếu đang trong phiên chọn hình ảnh

    _isPicking = true; // Đánh dấu là đang mở trình chọn hình ảnh
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    _isPicking = false; // Đánh dấu là không còn mở trình chọn hình ảnh

    if (selectedImages != null) {
      setState(() {
        imagesMoto = selectedImages;
      });
    }
  }

  Future<String> uploadImage(XFile image) async {
    final uploadUrl =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      uploadUrl,
      body: {
        'file': 'data:image/jpg;base64,$base64Image',
        'upload_preset': 'myimageupload', // Adjust with your preset
        'api_key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['secure_url'];
    } else {
      throw Exception('Error uploading image: ${response.reasonPhrase}');
    }
  }

  Future<void> _submitForm() async {
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

      // Upload each image and collect URLs
      List<String> imageUrls = [];
      for (var image in imagesMoto!) {
        String imageUrl = await uploadImage(image);
        imageUrls.add(imageUrl);
      }

      // Call service to add motorcycle with URLs
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
          SnackBar(content: Text('Motorcycle added successfully!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          imagesMoto = [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add motorcycle.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Motorcycle')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: numberPlateController,
                  decoration: InputDecoration(labelText: 'Number Plate'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a number plate' : null,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCompanyMoto,
                  decoration: InputDecoration(labelText: 'Company Name'),
                  items: companyMotoList.isEmpty
                      ? [
                          DropdownMenuItem(
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
                  validator: (value) =>
                      value == null ? 'Please select a company name' : null,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: 'Category Name'),
                  items: categoryList.isEmpty
                      ? [
                          DropdownMenuItem(
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
                TextFormField(
                  controller: nameMotoController,
                  decoration: InputDecoration(labelText: 'Motorcycle Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a motorcycle name' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter a price';
                    if (double.tryParse(value) == null)
                      return 'Please enter a valid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: energyController,
                  decoration: InputDecoration(labelText: 'Energy Type'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter energy type' : null,
                ),
                TextFormField(
                  controller: vehicleMassController,
                  decoration: InputDecoration(labelText: 'Vehicle Mass'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter vehicle mass';
                    if (double.tryParse(value) == null)
                      return 'Please enter a valid number';
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: pickImages,
                  child: Text('Pick Images'),
                ),
                SizedBox(height: 10),
                imagesMoto!.isEmpty
                    ? Text('No images selected.')
                    : Wrap(
                        spacing: 8.0,
                        children: imagesMoto!.map((image) {
                          return Image.file(
                            File(image.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
