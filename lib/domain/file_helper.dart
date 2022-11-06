import 'dart:io';

import 'package:simplebudget/services.dart';

// Models
import 'package:simplebudget/domain/models/sheets.dart';

// TODO Create file backups?

class FileHelper {
  late final File _file;

  // Get SheetsModel List
  Future<List<SheetsModel>> getSheetsList(int year, int month) async {
    // Create sheetsFile List variable
    List<SheetsModel> sheetsList = [];
    // Initialise File
    _file = await getSheetsFile();
    // Convert File to String
    String _sheetsString = await getSheetsString(_file);
    // Convert String to JSON
    List<dynamic> _sheetsJson = getSheetsJson(_sheetsString);
    // Check if JSON is not empty
    if (_sheetsJson.isNotEmpty) {
      // Convert JSON list to List<SheetsModel>
      sheetsList =
          _sheetsJson.map((sheet) => SheetsModel.fromJson(sheet)).toList();
      // Check if selected year SheetsModel does not exist
      if (!sheetsList.any((sheet) => sheet.year == year)) {
        // Create SheetsModel for selected year
        // Create Skeleton SheetsModel String
        String yearSheetString = createSkeleonString(year, month);
        // Convert Skeleton SheetsModel String to JSON
        dynamic yearSheetJson = getSheetsJson(yearSheetString);
        // Add Skeleton SheetsModel Object (converted from JSON) to SheetsModel List variable
        sheetsList.add(SheetsModel.fromJson(yearSheetJson));
        // Write updated SheetsModel List to File
        await writeToSheetsFile(sheetsList.listToString());
      }
    } else {
      // Write Skeleton SheetsModel String to File
      await writeToSheetsFile(createSkeleonString(year, month));
      // Reccuring Function Call
      getSheetsList(year, month);
    }
    return sheetsList;
  }

  // Write SheetsModel String to File
  writeToSheetsFile(String string) async {
    await _file.writeAsString(string);
  }
}
