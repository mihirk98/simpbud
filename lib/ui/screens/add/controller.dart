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

class AddScreenController {
  buildTransaction(BuildContext context, enums.Action action, int id,
      String desc, int amount) async {
    // Create TransactionModel
    TransactionModel transaction = TransactionModel(
      id: id,
      desc: desc,
      amount: amount,
    );

    // Call AddExpenditureTransaction Action
    await _presentationBloc
        .action(
          ActionModel(
            action: action,
            props: {"transaction": transaction},
          ),
          context,
        )
        .then(
          (status) => {
            operationFeedback(
              status,
              context,
              () => {
                // Hide keyboard
                FocusManager.instance.primaryFocus?.unfocus(),
                Navigator.of(context).pop(),
              },
            ),
          },
        );
  }
}
