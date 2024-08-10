import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ExcelService {
  // Function to pick and read an Excel file
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
      //  await parseExcelData(excel); // Process Excel data
      } catch (e) {
        print('Error reading file: $e');
        // Handle error, maybe show a snackbar
      }
    } else {
      // User canceled the picker
      print('File picker canceled');
    }
  }

  // Function to parse Excel data
  Future<void> parseExcelData(Excel excel) async {
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;
      for (var row in sheet.rows) {
        String? country = row[0]?.value.toString();
        String? state = row[1]?.value.toString();
        String? district = row[2]?.value.toString();
        String? city = row[3]?.value.toString();

        // Save data to Firebase Firestore
        await saveLocationToFirestore(
          country: country,
          state: state,
          district: district,
          city: city,
        );
        // Fetch weather report for the location
        if (city != null) {
          //  await fetchWeatherReport(city);
        }
      }
    }
  }

  // Function to save location data to Firebase Firestore
  Future<void> saveLocationToFirestore({
    String? country,
    String? state,
    String? district,
    String? city,
  }) async {
    CollectionReference locations =
        FirebaseFirestore.instance.collection('locations');

    await locations.add({
      'country': country ?? '',
      'state': state ?? '',
      'district': district ?? '',
      'city': city ?? '',
    }).catchError((e) {
      print('Error saving to Firestore: $e');
      // Handle error
    });
  }

  // Function to fetch weather reports
  Future<void> fetchWeatherReport(String city) async {
    String apiKey = ''; // Replace with your API key
    String url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var weatherData = response.body;
         // Handle the weather data as needed (e.g., store it, display it)
      } else {
        print('Error fetching weather data: ${response.statusCode}');
        // Handle API error
      }
    } catch (e) {
      print('Error making API request: $e');
      // Handle network error
    }
  }
}
