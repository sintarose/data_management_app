import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ExcelService {
  // ...

  Future<void> pickAndReadExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        var bytes = await file.readAsBytes(); // Asynchronous file reading
        var excel = Excel.decodeBytes(bytes);

        print('Excel file decoded: ${excel.tables.keys}');

        await parseExcelData(excel); // Process Excel data
      } catch (e) {
        print('Error reading file: $e');
        // Handle error, maybe show a snackbar
      }
    } else {
      // User canceled the picker
      print('File picker canceled');
    }
  }

  Future<void> parseExcelData(Excel excel) async {
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;
      print('Sheet: $table, Rows: ${sheet.rows.length}');

      // for (var row in sheet.rows) {
      //   String? country = row[0]?.value.toString();
      //   String? state = row[1]?.value.toString();
      //   String? district = row[2]?.value.toString();
      //   String? city = row[3]?.value.toString();

      //   print('Row: $country, $state, $district, $city');

      //   // Save data to Firebase Firestore
      //   await saveLocationToFirestore(
      //     country: country,
      //     state: state,
      //     district: district,
      //     city: city,
      //   );
      //   // Fetch weather report for the location
      //   if (city != null) {
      //     //  await fetchWeatherReport(city);
      //   }
      // }
    }
  }

  Future<void> saveLocationToFirestore({
    String? country,
    String? state,
    String? district,
    String? city,
  }) async {
    CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');

    try {
      await locations.add({
        'country': country ?? '',
        'state': state ?? '',
        'district': district ?? '',
        'city': city ?? '',
      });
      print('Data saved to Firestore: $country, $state, $district, $city');
    } catch (e) {
      print('Error saving to Firestore: $e');
      // Handle error
    }
  }

  // ...
}