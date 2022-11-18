import 'package:flutter/material.dart';

// Dialogs
import 'package:simplebudget/ui/dialogs/category_edit_dialog.dart';

Future<Map> showEditCategoryDialog(
    BuildContext context, String id, int budget) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) =>
        EditCategoryDialog(id: id, budget: budget),
  );
}
