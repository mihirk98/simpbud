import 'package:flutter/material.dart';

// Dialogs
import 'package:simplebudget/ui/dialogs/confirmation/dialog.dart';

Future<bool> showConfirmationDialog(BuildContext context) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => const ConfirmationDialog(),
  );
}
