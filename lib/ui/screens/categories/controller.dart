import 'package:simplebudget/ui/dialogs/category_edit/controller.dart';
import 'package:simplebudget/ui/utils.dart';

// Blocs
import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;

// Controllers
import 'package:simplebudget/blocs/presentation.dart';

// Models
import 'package:simplebudget/domain/models/action.dart';
import 'package:simplebudget/domain/models/category.dart';

final PresentationBloc _presentationBloc = PresentationBloc();

class CategoriesScreenController {
  updateCategory(
      BuildContext context, CategoryModel category, int budget) async {
    await showEditCategoryDialog(
      context,
      category,
      budget,
    ).then(
      (decision) => {
        if (decision["decision"])
          _presentationBloc
              .action(
                ActionModel(
                  action: enums.Action.updateCategory,
                  props: {
                    "category": category,
                    "id": decision["id"],
                    "budget": decision["budget"],
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
              ),
      },
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
              "id": idController.text,
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
