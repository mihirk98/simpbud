import 'package:flutter/material.dart';

import 'package:simplebudget/ui/utils.dart';

// Blocs
import 'package:simplebudget/blocs/presentation.dart';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;

// Models
import 'package:simplebudget/domain/models/action.dart';
import 'package:simplebudget/domain/models/transcation.dart';

final PresentationBloc _presentationBloc = PresentationBloc();

class TransactionWidgetController {
  deleteTransaction(
      BuildContext context, int type, TransactionModel transaction) async {
    // 0 is income, 1 is expenditure
    await _presentationBloc
        .action(
          ActionModel(
            action: type == 0
                ? enums.Action.deleteIncomeTransaction
                : enums.Action.deleteExpenditureTransaction,
            props: {
              "transaction": transaction,
            },
          ),
          context,
        )
        .then(
          (status) => {
            operationFeedback(status, context, () => {}),
          },
        );
  }
}
