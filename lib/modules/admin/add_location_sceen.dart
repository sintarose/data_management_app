import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_management_app/auth_service/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_utilities/dialog_helper.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  // Text field controllers
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // fire base data collection
  final CollectionReference fetchData =
  FirebaseFirestore.instance.collection("SaveData");

  // Method to validate inputs
  bool _validateInputs() {
    if (_countryController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _cityController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Add Location'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
             const SizedBox(height: 30),
              _buildTextField(
                controller: _countryController,
                labelText: 'Country',
                icon: Icons.public,
              ),
            const  SizedBox(height: 16),
              _buildTextField(
                controller: _stateController,
                labelText: 'State',
                icon: Icons.map,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _districtController,
                labelText: 'District',
                icon: Icons.location_city,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cityController,
                labelText: 'City',
                icon: Icons.location_pin,
              ),
              const  SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_validateInputs()) {
                    await fetchData.add({
                      "Country": _countryController.text,
                      "State": _stateController.text,
                      "District": _districtController.text,
                      "City": _cityController.text,
                    });
                    _countryController.clear();
                    _stateController.clear();
                    _districtController.clear();
                    _cityController.clear();
                    showSuccessDialog(context);
                    Get.to(const LoginScreen());
                  } else {
                    showValidationError(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Add Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              Text(
                'Ensure all fields are filled out correctly before submitting.',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.location_on,
                size: 60,
                color: Colors.blueAccent.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.blue.shade800,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.blue.shade800,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
