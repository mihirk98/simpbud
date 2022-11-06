import 'package:flutter/material.dart';

// Blocs
import 'package:simplebudget/blocs/data.dart';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;
import 'package:simplebudget/ui/controllers/dialogs/confirmation_dialog.dart';

// Controllers
import 'package:simplebudget/ui/controllers/dialogs/operation_dialog.dart';

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
        _decision =
            await showConfirmationDialog(context).then((decision) => decision);
        if (_decision) showOperationDialog(context);
        break;
      case enums.Action.addExpenditureTransaction:
      case enums.Action.addIncomeTransaction:
      case enums.Action.updateCategoryBudget:
      case enums.Action.addCategory:
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
