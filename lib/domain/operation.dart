import 'package:simplebudget/domain/models/transcation.dart';
import 'package:simplebudget/services.dart';
import 'package:simplebudget/domain/file_helper.dart';

// Models
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/sheets.dart';

class Operation {
  final FileHelper _fileHelper;
  final List<SheetsModel> _sheets;
  final int _year;
  final int _month;
  final Map<String, dynamic> _props;
  late final SheetsModel _updatedSheetsModel;

  Operation(
      this._fileHelper, this._sheets, this._year, this._month, this._props) {
    _updatedSheetsModel =
        _sheets.firstWhere((sheet) => sheet.year == _year).copyWith();
  }

  writeUpdatedSheetsList() async {
    await _fileHelper.writeToSheetsFile(
      _sheets.listToString(),
    );
  }

  ////// Operations
  //// Create
  // Month value -1 because Month ranges from 1 .. 12 hence -1 for arrays which range from 0 .. 11
  addExpenditureTransaction() =>
      _updatedSheetsModel.sheets[_month - 1].expenditure.transactions
          .add(_props["transaction"]);

  addIncomeTransaction() =>
      _updatedSheetsModel.sheets[_month - 1].income.transactions
          .add(_props["transaction"]);

  addCategory() {
    _updatedSheetsModel.sheets[_month - 1].expenditure.categories.add(
      CategoryModel(
        id: _props["id"],
        budget: _props["budget"],
        expenditure: 0,
      ),
    );
  }

  //// Read
  List<SheetsModel> getSheets() => _sheets;

  //// Update
  // Update active sheet in sheets list
  updateSheets() =>
      _sheets[_sheets.indexWhere((sheet) => sheet.year == _year)] =
          _updatedSheetsModel;

  // Update expenditure total field value of active sheet (transaction amount is added to previous total, check ExpenditureModel)
  updateExpenditureTotal(bool negative) =>
      _updatedSheetsModel.sheets[_month - 1] =
          _updatedSheetsModel.sheets[_month - 1].copyWith(
              expenditure: _updatedSheetsModel.sheets[_month - 1].expenditure
                  .copyWith(
                      total: negative == true
                          ? -_props["transaction"].amount
                          : _props["transaction"].amount));

  // Update category expenditure field value of active sheet (transaction amount is added to previous expenditure field value, check CategoryModel)
  updateCategoryExpenditureTransaction(bool negative) {
    int _categoryIndex = _updatedSheetsModel
        .sheets[_month - 1].expenditure.categories
        .indexWhere((category) => category.id == _props["transaction"].desc);
    updateCategoryExpenditure(
        _categoryIndex,
        negative == true
            ? -_props["transaction"].amount
            : _props["transaction"].amount);
  }

  // Update category
  updateCategory() {
    int _categoryIndex = _updatedSheetsModel
        .sheets[_month - 1].expenditure.categories
        .indexWhere((category) => category.id == _props["category"].id);
    _updatedSheetsModel
            .sheets[_month - 1].expenditure.categories[_categoryIndex] =
        _updatedSheetsModel
            .sheets[_month - 1].expenditure.categories[_categoryIndex]
            .copyWith(id: _props["id"], budget: _props["budget"]);
  }

  // Update category transactions
  updateCategoryTransactions() {
    List<TransactionModel> _updatedTransations = [];
    for (TransactionModel transaction
        in _updatedSheetsModel.sheets[_month - 1].expenditure.transactions) {
      if (transaction.desc == _props["category"].id) {
        _updatedTransations.add(
          transaction.copyWith(
            desc: _props["id"],
          ),
        );
      } else {
        _updatedTransations.add(transaction);
      }
      _updatedSheetsModel.sheets[_month - 1] =
          _updatedSheetsModel.sheets[_month - 1].copyWith(
        expenditure:
            _updatedSheetsModel.sheets[_month - 1].expenditure.copyWith(
          transactions: _updatedTransations,
        ),
      );
    }
  }

  // Update category expenditure field value of active sheet by total
  updateCategoryExpenditureTotal() {
    int totalCategoryExpenditure = 0;
    for (TransactionModel transaction
        in _updatedSheetsModel.sheets[_month - 1].expenditure.transactions) {
      if (transaction.desc == _props["category"].id) {
        totalCategoryExpenditure += transaction.amount;
      }
    }
    int _categoryIndex = _updatedSheetsModel
        .sheets[_month - 1].expenditure.categories
        .indexWhere((category) => category.id == _props["id"]);
    updateCategoryExpenditure(_categoryIndex, totalCategoryExpenditure);
  }

  // Update category expenditure
  updateCategoryExpenditure(categoryIndex, amount) => _updatedSheetsModel
          .sheets[_month - 1].expenditure.categories[categoryIndex] =
      _updatedSheetsModel
          .sheets[_month - 1].expenditure.categories[categoryIndex]
          .copyWith(expenditure: amount);

  // Update income total field value of active sheet (transaction amount is added to previous total, check IncomeModel)
  updateIncomeTotal(bool negative) => _updatedSheetsModel.sheets[_month - 1] =
      _updatedSheetsModel.sheets[_month - 1].copyWith(
          income: _updatedSheetsModel.sheets[_month - 1].income.copyWith(
              total: negative == true
                  ? -_props["transaction"].amount
                  : _props["transaction"].amount));

  // Update active sheet with updated category list
  updateCategoriesList() => _updatedSheetsModel.sheets[_month - 1] =
          _updatedSheetsModel.sheets[_month - 1].copyWith(
        expenditure:
            _updatedSheetsModel.sheets[_month - 1].expenditure.copyWith(
          categories:
              _updatedSheetsModel.sheets[_month - 1].expenditure.categories,
        ),
      );

  //// Delete
  deleteIncomeTransaction() =>
      _updatedSheetsModel.sheets[_month - 1].income.transactions
          .remove(_props["transaction"]);

  deleteExpenditureTransaction() =>
      _updatedSheetsModel.sheets[_month - 1].expenditure.transactions
          .remove(_props["transaction"]);

  deleteCategory() =>
      _updatedSheetsModel.sheets[_month - 1].expenditure.categories
          .remove(_props["category"]);
}
