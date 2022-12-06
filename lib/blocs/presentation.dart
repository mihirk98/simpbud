import 'package:flutter/material.dart';

// Blocs
import 'package:simplebudget/blocs/data.dart';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;

// Controllers
import 'package:simplebudget/ui/dialogs/confirmation/controller.dart';
import 'package:simplebudget/ui/dialogs/operation/controller.dart';

// Models
import 'package:simplebudget/domain/models/action.dart';

final DataBloc _dataBloc = DataBloc();

class PresentationBloc {
  // Singleton
  static final PresentationBloc _presentationBlocSingleton =
      PresentationBloc._internal();

  factory PresentationBloc() {
    return _presentationBlocSingleton;
  }

  PresentationBloc._internal();

  // Actions
  Future<Map<String, bool>> action(
      ActionModel action, BuildContext context) async {
    bool _dialog = true;
    bool _decision = true;
    switch (action.action) {
      case enums.Action.setActiveSheet:
        _dialog = false;
        break;
      case enums.Action.deleteExpenditureTransaction:
      case enums.Action.deleteIncomeTransaction:
      case enums.Action.deleteCategory:
      case enums.Action.mergeCategories:
        _decision =
            await showConfirmationDialog(context).then((decision) => decision);
        if (_decision) showOperationDialog(context);
        break;
      case enums.Action.addExpenditureTransaction:
      case enums.Action.addIncomeTransaction:
      case enums.Action.addCategory:
      case enums.Action.updateCategory:
        // Show Operation Dialog
        showOperationDialog(context);
        break;
    }
    if (_decision) {
      return {
        "decision": _decision,
        "success": await _dataBloc.event(action),
        "dialog": _dialog
      };
    } else {
      return {"decision": _decision};
    }
  }
}
