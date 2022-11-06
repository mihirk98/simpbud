import 'package:flutter/material.dart';

// Dialogs
import 'package:simplebudget/ui/dialogs/operation_dialog.dart';

void showOperationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => const OperationDialog(),
  );
}
