import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Blocs
import 'package:simplebudget/blocs/data.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/radius.dart' as radius;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Models
import 'package:simplebudget/domain/models/category.dart';

final DataBloc _dataBloc = DataBloc();
final _editCategoryFormKey = GlobalKey<FormState>();
final TextEditingController _idController = TextEditingController();
final TextEditingController _budgetController = TextEditingController();

class EditCategoryDialog extends StatelessWidget {
  final CategoryModel category;
  final int budget;
  const EditCategoryDialog(
      {required this.category, required this.budget, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(borderRadius: radius.widget),
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Container(
            alignment: Alignment.center,
            decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
            child: Form(
              key: _editCategoryFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: paddings.widget,
                    child: Text(
                      strings.editCategory,
                      style: styles.heading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, right: 4.0, bottom: 4.0),
                    child: TextFormField(
                      controller: _idController..text = category.id,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return strings.validCategory;
                        } else if (value == category.id) {
                          return null;
                        } else if (_dataBloc.getCategories
                            .any((category) => category.id == value)) {
                          return strings.categoryExists;
                        }
                        return null;
                      },
                      style: styles.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, right: 4.0, bottom: 20.0),
                    child: TextFormField(
                      controller: _budgetController..text = budget.toString(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return strings.validBudget;
                        }
                        return null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: styles.text,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: utils.widgetBox(
                            colors.green,
                            const BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () => {
                              if (_editCategoryFormKey.currentState!.validate())
                                Navigator.pop(
                                  context,
                                  {
                                    "decision": true,
                                    "id": _idController.text,
                                    "budget": int.parse(_budgetController.text),
                                  },
                                )
                            },
                            child: const Text(
                              strings.yes,
                              style: styles.text,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: utils.widgetBox(
                            colors.red,
                            const BorderRadius.only(
                              bottomRight: Radius.circular(16.0),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pop(context, {"decision": false}),
                            child: const Text(
                              strings.no,
                              style: styles.text,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
