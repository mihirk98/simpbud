import 'package:flutter/material.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/margins.dart' as margins;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/radius.dart' as radius;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Controllers
import 'package:simplebudget/ui/controllers/screens/categories.dart';

// Models
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/sheet.dart';

// Widgets
import 'package:simplebudget/ui/widgets/amount.dart';

class CategoriesCategoryWidget extends StatefulWidget {
  const CategoriesCategoryWidget({
    Key? key,
    required AsyncSnapshot<SheetModel> snapshot,
    required CategoryModel category,
    required CategoriesScreenController controller,
  })  : _snapshot = snapshot,
        _category = category,
        _controller = controller,
        super(key: key);

  final AsyncSnapshot<SheetModel> _snapshot;
  final CategoryModel _category;
  final CategoriesScreenController _controller;

  @override
  State<CategoriesCategoryWidget> createState() =>
      _CategoriesCategoryWidgetState();
}

class _CategoriesCategoryWidgetState extends State<CategoriesCategoryWidget> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    int _categoriesLength =
        widget._snapshot.data!.expenditure.categories.length;
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Container(
        decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
        margin: margins.content,
        padding: paddings.content,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: paddings.content,
              child: Text(
                widget._category.id,
                style: styles.heading,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: paddings.content.copyWith(top: 0, bottom: 0),
              child: AmountTextWidget(
                text: widget._category.budget.toString(),
                style: styles.heading,
              ),
            ),
            _errorMessage != null
                ? Padding(
                    padding: paddings.content,
                    child: Text(
                      _errorMessage!,
                      style: styles.error,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => {
                    if (widget._snapshot.data!.expenditure.transactions.any(
                        (transaction) =>
                            transaction.desc == widget._category.id))
                      {
                        setState(() {
                          _errorMessage = strings.deleteCategoryTransactions;
                        }),
                      }
                    else if (_categoriesLength == 1)
                      {
                        setState(() {
                          _errorMessage = strings.zeroCategories;
                        }),
                      }
                    else
                      {
                        widget._controller.deleteCategory(
                          context,
                          widget._category,
                        ),
                      }
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline_sharp,
                    color: colors.red,
                    size: 20.0,
                  ),
                ),
                IconButton(
                  onPressed: () => widget._controller.updateCategory(
                      context, widget._category.id, widget._category.budget),
                  icon: const Icon(
                    Icons.edit,
                    color: colors.text,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
