
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';



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
     
        // Save the data to Firestore
      
      }
    }
  }

  // ...

 

