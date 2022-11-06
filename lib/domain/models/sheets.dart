// Models
import 'package:simplebudget/domain/models/sheet.dart';

// TODO Remove month cause it ain't helping remove get functions in data bloc

class SheetsModel {
  final int year;
  final int month;
  final List<SheetModel> sheets;

  SheetsModel({required this.year, required this.month, required this.sheets});

  SheetsModel copyWith({
    int? year,
    int? month,
    List<SheetModel>? sheets,
  }) {
    return SheetsModel(
        year: year ?? this.year,
        month: month ?? this.month,
        sheets: sheets ?? this.sheets);
  }

  factory SheetsModel.fromJson(Map<String, dynamic> json) => SheetsModel(
        year: json['year'],
        month: json['month'],
        sheets: (json['sheets'] as List)
            .map((sheet) => SheetModel.fromJson(sheet))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        '"year"': year,
        '"month"': month,
        '"sheets"': sheets.map((sheet) => sheet.toJson()).toList(),
      };
}
