import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_management_app/app_utilities/dialog_helper.dart';
import 'package:data_management_app/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UserDashboard> {
  final ExcelService _excelService = ExcelService();
  final CollectionReference fetchData =
      FirebaseFirestore.instance.collection("SaveData");

  // Method to show the loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children:  [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Processing..."),
            ],
          ),
        );
      },
    );
  }

  // Method to hide the loading dialog
  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  // to upload excel
  void _uploadExcelFile() async {
    _showLoadingDialog(); // Show loading dialog

    var status = await Permission.photos.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await openAppSettings();
    }

    // Checking permission
    if (await Permission.photos.isGranted ||
        await Permission.photos.isLimited) {
      try {
        await _excelService.pickAndReadExcelFile();
        showSnackBar('Excel file processed successfully!', Colors.green);
      } catch (e) {
       
        showSnackBar('Error processing Excel file, try another file', Colors.red);
      } finally {
        _hideLoadingDialog(); // Hide loading dialog
      }
    } else {
      _hideLoadingDialog(); // Hide loading dialog if permission is not granted
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Fetch Data From Firebase"),
      ),
      body: StreamBuilder(
        stream: fetchData.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['District'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              documentSnapshot['City'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              documentSnapshot['State'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: _uploadExcelFile,
                          child: const Text("Upload Excel"),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
