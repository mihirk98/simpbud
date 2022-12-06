import 'dart:async';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;

// Models
import 'package:simplebudget/domain/models/action.dart';
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/sheet.dart';
import 'package:simplebudget/domain/models/sheets.dart';

// Repositories
import 'package:simplebudget/domain/repository.dart';

// TODO Clean up all get functions to use only streams?

class DataBloc {
  // Singleton
  static final DataBloc _dataBlocSingleton = DataBloc._internal();
  final AppRepository _appRepository = AppRepository();

  // Streams
  // Share active sheet with UI
  final StreamController<SheetModel> _activeSheetController =
      StreamController<SheetModel>.broadcast();
  Stream<SheetModel> get activeSheetStream => _activeSheetController.stream;

  factory DataBloc() {
    return _dataBlocSingleton;
  }

  DataBloc._internal() {
    // Listen to active sheet updates in repository
    _appRepository.activeSheetValueNotifier.addListener(
      () => _activeSheetController
          .add(_appRepository.activeSheetValueNotifier.value!),
    );
  }

  // Get
  int get getMonth => _appRepository.getMonth;
  SheetModel get getActiveSheet =>
      _appRepository.activeSheetValueNotifier.value!;
  List<SheetsModel> get getSheets => _appRepository.getSheets;
  List<CategoryModel> get getCategories => _appRepository.getCategories;

  // Events
  Future<bool> event(ActionModel action) async {
    switch (action.action) {
      case enums.Action.setActiveSheet:
        _appRepository.updateActiveSheet(
            action.props["year"], action.props["month"]);
        return true;
      case enums.Action.addExpenditureTransaction:
        return await _appRepository
            .operation(
              _appRepository.addExpenditureTransaction,
              action.props,
            )
            .then((success) => success);
      case enums.Action.addIncomeTransaction:
        return await _appRepository
            .operation(
              _appRepository.addIncomeTransaction,
              action.props,
            )
            .then((success) => success);
      case enums.Action.deleteExpenditureTransaction:
        return await _appRepository
            .operation(
              _appRepository.deleteExpenditureTransaction,
              action.props,
            )
            .then((success) => success);
      case enums.Action.deleteIncomeTransaction:
        return await _appRepository
            .operation(
              _appRepository.deleteIncomeTransaction,
              action.props,
            )
            .then((success) => success);
      case enums.Action.updateCategory:
        return await _appRepository
            .operation(
              _appRepository.updateCategory,
              action.props,
            )
            .then((success) => success);
      case enums.Action.addCategory:
        return await _appRepository
            .operation(
              _appRepository.addCategory,
              action.props,
            )
            .then((success) => success);
      case enums.Action.deleteCategory:
        return await _appRepository
            .operation(
              _appRepository.deleteCategory,
              action.props,
            )
            .then((success) => success);
      case enums.Action.mergeCategories:
        return await _appRepository
            .operation(
              _appRepository.mergeCategories,
              action.props,
            )
            .then((success) => success);
    }
  }

  void dispose() {
    _activeSheetController.close();
  }
}
