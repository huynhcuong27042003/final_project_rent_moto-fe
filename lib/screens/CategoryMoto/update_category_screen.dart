// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class UpdateCategoryScreen extends StatefulWidget {
  final String id;
  final String currentName;
  final bool currentIsHide;
  final Function(String, String, bool) onUpdate;

  const UpdateCategoryScreen({
    super.key,
    required this.id,
    required this.currentName,
    required this.currentIsHide,
    required this.onUpdate,
  });

  @override
  _UpdateCategoryScreenState createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  late TextEditingController nameController;
  late bool isHide;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    isHide = widget.currentIsHide; // Initialize the state variable
  }

  @override
  void dispose() {
    nameController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Update Category Motto',
        style:
            TextStyle(color: Colors.blue), // Set the title color to blue
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text(
              'Hiden',
              style: TextStyle(color: Colors.blue),
            ),
            value: isHide,
            onChanged: (value) {
              setState(() {
                isHide = value; // Update the state variable
              });
            },
            activeColor: Colors.blue, // Optional: active color customization
            inactiveThumbColor: Colors.grey, // Optional: inactive color
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel the dialog
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            backgroundColor:
                Colors.grey[300], // Background color for Cancel button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cancel',
            style:
                TextStyle(color: Colors.blue), // Text color for Cancel button
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onUpdate(
                widget.id, nameController.text, isHide); // Pass updated data
            Navigator.of(context).pop(); // Close dialog after update
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            backgroundColor: Colors.blue, // Background color for Update button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Update',
            style:
                TextStyle(color: Colors.white), // Text color for Update button
          ),
        ),
      ],
    );
  }
}
