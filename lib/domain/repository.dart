import 'package:flutter/material.dart';

// Domain
import 'package:simplebudget/domain/file_helper.dart';
import 'package:simplebudget/domain/operation.dart';

// Models
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/sheet.dart';
import 'package:simplebudget/domain/models/sheets.dart';

class AppRepository {
  final FileHelper _fileHelper = FileHelper();
  late List<SheetsModel> _sheets;
  late int _year;
  late int _month;

  // TODO activeSheetValueNotifier is nullable?
  // Changes to lists not reflected in ValueNotifiers
  final ValueNotifier<SheetModel?> activeSheetValueNotifier =
      ValueNotifier(null);

  AppRepository() {
    // Set Year
    _year = DateTime.now().year;
    // Set Month
    _month = DateTime.now().month;
    // Get SheetsModel List
    _fileHelper.getSheetsList(_year, _month).then(
          (sheets) => {
            // Set Sheets
            _sheets = sheets,
            // Set Active Sheet
            activeSheetValueNotifier.value = getSheet,
          },
        );
  }

  dispose() {
    activeSheetValueNotifier.dispose();
  }

  // Operations
  Future<bool> operation(Function function, Map<String, dynamic> props) async {
    try {
      // Create Operation
      final Operation _operation = Operation(_fileHelper, _sheets, _year,
          _month, activeSheetValueNotifier.value!, props);
      // Call function
      function(_operation);
      // Update sheets
      _operation.updateSheets();
      // Write updated SheetsModel List to File
      await _operation.writeUpdatedSheetsList();
      // Get sheets
      _sheets = _operation.getSheets();
      // Update active sheet
      activeSheetValueNotifier.value = getSheet;
      return true;
    } catch (_) {
      return false;
    }
  }

  // Create
  addExpenditureTransaction(Operation operation) {
    // Update expenditure total field value of active sheet
    operation.updateExpenditureTotal(false);
    // Add expenditure transaction
    operation.addExpenditureTransaction();
    // Update category expenditure field value of active sheet
    operation.updateCategoryExpenditure(false);
  }

  addIncomeTransaction(Operation operation) async {
    // Update income total field value of active sheet
    operation.updateIncomeTotal(false);
    // Add income transaction
    operation.addIncomeTransaction();
  }

  addCategory(Operation operation) {
    // Add Category
    operation.addCategory();
    // Update Categories List
    operation.updateCategoriesList();
  }

  // Read
  int get getMonth => _month;
  List<SheetsModel> get getSheets => _sheets;
  SheetModel get getSheet =>
      _sheets.firstWhere((sheet) => sheet.year == _year).sheets[_month - 1];
  List<CategoryModel> get getCategories =>
      activeSheetValueNotifier.value!.expenditure.categories;

  // Update
  updateActiveSheet(int year, int month) {
    _year = year;
    _month = month;
    activeSheetValueNotifier.value = getSheet;
  }

  updateCategory(Operation operation) {
    // Update category
    operation.updateCategory();
    // Update category transactions
    operation.updateCategoryTransactions();
  }

  // Delete
  deleteExpenditureTransaction(Operation operation) {
    // Update expenditure total field value of active sheet
    operation.updateExpenditureTotal(true);
    // Remove expenditure transaction
    operation.deleteExpenditureTransaction();
    // Update category expenditure field value of active sheet
    operation.updateCategoryExpenditure(true);
  }

  deleteIncomeTransaction(Operation operation) {
    // Update income total field value of active sheet
    operation.updateIncomeTotal(true);
    // Remove income transaction
    operation.deleteIncomeTransaction();
  }

  deleteCategory(Operation operation) {
    // Delete Category
    operation.deleteCategory();
    // Update Categories List
    operation.updateCategoriesList();
  }
}
