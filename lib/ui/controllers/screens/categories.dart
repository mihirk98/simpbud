import 'package:simplebudget/ui/utils.dart';

// Blocs
import 'package:flutter/material.dart';
import 'package:simplebudget/blocs/presentation.dart';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;

// Models
import 'package:simplebudget/domain/models/action.dart';
import 'package:simplebudget/domain/models/category.dart';

final PresentationBloc _presentationBloc = PresentationBloc();

class CategoriesScreenController {
  updateCategory(BuildContext context, String category, int budget) {
    _presentationBloc
        .action(
          ActionModel(
            action: enums.Action.updateCategoryBudget,
            props: {
              "category": category,
              "budget": budget,
            },
          ),
          context,
        )
        .then(
          (status) => operationFeedback(
            status,
            context,
            () => {},
          ),
        );
  }

  addCategory(
    BuildContext context,
    TextEditingController idController,
    TextEditingController budgetController,
  ) {
    _presentationBloc
        .action(
          ActionModel(
            action: enums.Action.addCategory,
            props: {
              "category": idController.text,
              "budget": int.parse(budgetController.text),
            },
          ),
          context,
        )
        .then(
          (status) => operationFeedback(
            status,
            context,
            () => {
              FocusManager.instance.primaryFocus?.unfocus(),
              idController.text = "",
              budgetController.text = "",
            },
          ),
        );
  }

  deleteCategory(BuildContext context, CategoryModel category) {
    _presentationBloc
        .action(
          ActionModel(
            action: enums.Action.deleteCategory,
            props: {
              "category": category,
            },
          ),
          context,
        )
        .then(
          (status) => operationFeedback(
            status,
            context,
            () => {},
          ),
        );
  }
}
