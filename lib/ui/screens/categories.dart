import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Blocs
import 'package:simplebudget/blocs/data.dart';

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
import 'package:simplebudget/ui/widgets/scaffold.dart';

// TODO Budget text field error on delete
// TODO Mosiac for wrap

final DataBloc _dataBloc = DataBloc();
final CategoriesScreenController _controller = CategoriesScreenController();

final _addCategoryFormKey = GlobalKey<FormState>();
final TextEditingController _idController = TextEditingController();
final TextEditingController _budgetController = TextEditingController();

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        appBar: true,
        title: strings.categories,
        actions: [
          buildNewCategoryButton(context),
        ],
        back: true,
        body: buildBody(context),
        fab: null,
        fabLocation: null);
  }

  Widget buildNewCategoryButton(BuildContext context) {
    return IconButton(
      onPressed: () => {
        if (_addCategoryFormKey.currentState!.validate())
          {
            _controller.addCategory(
              context,
              _idController,
              _budgetController,
            )
          }
      },
      icon: const Icon(
        Icons.add,
        color: colors.appBarIcon,
        size: 24.0,
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<SheetModel>(
          stream: _dataBloc.activeSheetStream,
          initialData: _dataBloc.getActiveSheet,
          builder: (context, snapshot) {
            return Column(
              children: [
                buildCategoriesList(context, snapshot),
                buildNewCategoryForm(snapshot),
              ],
            );
          }),
    );
  }

  Widget buildCategoriesList(
      BuildContext context, AsyncSnapshot<SheetModel> snapshot) {
    final List<CategoryModel> _categories =
        snapshot.data!.expenditure.categories;
    return Expanded(
      child: Container(
          margin: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
          child: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: _categories.map((category) {
                return CategoriesCategoryWidget(
                  snapshot: snapshot,
                  categories: _categories,
                  category: category,
                );
              }).toList(),
            ),
          )),
    );
  }

  Builder buildNewCategoryForm(AsyncSnapshot<SheetModel> snapshot) {
    return Builder(builder: (context) {
      return Container(
        color: colors.tertiary,
        padding: paddings.content,
        child: Form(
          key: _addCategoryFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _idController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return strings.validCategory;
                  } else if (snapshot.data!.expenditure.categories
                      .any((category) => category.id == value)) {
                    return strings.categoryExists;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: colors.widgetBackground,
                  hintText: strings.categoryHint,
                ),
                style: styles.text,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _budgetController,
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
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: colors.widgetBackground,
                        hintText: strings.budgetHint,
                        helperText: strings.noBudget,
                      ),
                      style: styles.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CategoriesCategoryWidget extends StatefulWidget {
  const CategoriesCategoryWidget({
    Key? key,
    required AsyncSnapshot<SheetModel> snapshot,
    required List<CategoryModel> categories,
    required CategoryModel category,
  })  : _snapshot = snapshot,
        _categories = categories,
        _category = category,
        super(key: key);

  final AsyncSnapshot<SheetModel> _snapshot;
  final List<CategoryModel> _categories;
  final CategoryModel _category;

  @override
  State<CategoriesCategoryWidget> createState() =>
      _CategoriesCategoryWidgetState();
}

class _CategoriesCategoryWidgetState extends State<CategoriesCategoryWidget> {
  final _editCategoryBudgetController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    _editCategoryBudgetController.text = widget._category.budget.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget._category.id);
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
              padding: paddings.content,
              child: Focus(
                onFocusChange: (focus) {
                  if (!focus) {
                    if (_editCategoryBudgetController.text.isNotEmpty) {
                      if (_editCategoryBudgetController.text !=
                          widget._category.budget.toString()) {
                        _controller.updateCategory(
                          context,
                          widget._category.id,
                          int.parse(_editCategoryBudgetController.text),
                        );
                      }
                    } else {
                      _editCategoryBudgetController.text =
                          widget._category.budget.toString();
                    }
                  }
                },
                child: TextField(
                  controller: _editCategoryBudgetController,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorText: _errorMessage,
                    prefixText: strings.currency,
                  ),
                  style: styles.text,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => {
                  if (widget._snapshot.data!.expenditure.transactions.any(
                      (transaction) => transaction.desc == widget._category.id))
                    {
                      setState(() {
                        _errorMessage = strings.deleteCategoryTransactions;
                      }),
                    }
                  else if (widget._categories.length == 1)
                    {
                      setState(() {
                        _errorMessage = strings.zeroCategories;
                      }),
                    }
                  else
                    {
                      _controller.deleteCategory(
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
            ),
          ],
        ),
      ),
    );
  }
}
