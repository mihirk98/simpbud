import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

// File functions
Future<File> getSheetsFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final file = File('$path/sheets.json');
  if (!file.existsSync()) file.createSync(recursive: true);
  return file;
}

Future<String> getSheetsString(File file) async => await file.readAsString();

List<dynamic> getSheetsJson(String string) {
  if (string.isNotEmpty) {
    return jsonDecode(string);
  } else {
    return jsonDecode("[]");
  }
}

String createSkeleonString(int year, int month) {
  return "[{\"year\": $year, \"month\": $month, \"sheets\": [{\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}, {\"expenditure\": {\"transactions\": [], \"categories\": [{\"id\": \"Miscellaneous\"}], \"total\": 0}, \"income\": {\"transactions\": [], \"total\": 0}}]}]";
}

// Extensions
extension ToString on List {
  String listToString() {
    return map((sheets) => sheets.toJson()).toList().toString();
  }
}
