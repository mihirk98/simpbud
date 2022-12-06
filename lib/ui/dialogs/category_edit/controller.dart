import 'package:flutter/material.dart';
import 'package:simplebudget/domain/models/category.dart';

// Dialogs
import 'package:simplebudget/ui/dialogs/category_edit/dialog.dart';

Future<Map> showEditCategoryDialog(
    BuildContext context, CategoryModel category, int budget) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) =>
        EditCategoryDialog(category: category, budget: budget),
  );
}
