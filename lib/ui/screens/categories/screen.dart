import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Blocs
import 'package:simplebudget/blocs/data.dart';
import 'package:simplebudget/blocs/navigation.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/enums.dart' as enums;
import 'package:simplebudget/consts/margins.dart' as margins;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/radius.dart' as radius;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Controllers
import 'package:simplebudget/ui/screens/categories/controller.dart';

// Models
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/sheet.dart';

// Widgets
import 'package:simplebudget/ui/screens/categories/widgets/category.dart';
import 'package:simplebudget/ui/widgets/skeleton/scaffold.dart';

// TODO Tests?? Yes Yes
// TODO Mosiac for wrap

final DataBloc _dataBloc = DataBloc();
final NavigationBloc _navigationBloc = NavigationBloc();
final CategoriesScreenController _controller = CategoriesScreenController();

final _addCategoryFormKey = GlobalKey<FormState>();
final TextEditingController _idController = TextEditingController();
final TextEditingController _budgetController = TextEditingController();

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  ScaffoldWidget buildScaffold(BuildContext context) {
    return ScaffoldWidget(
        appBar: true,
        title: strings.categories,
        actions: [
          buildMergeCategoriesButton(context),
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

  Widget buildMergeCategoriesButton(BuildContext context) {
    return IconButton(
      onPressed: () =>
          _navigationBloc.navigateTo(enums.Navigation.merge, context),
      icon: const Icon(
        Icons.merge,
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
          margin: margins.widget.copyWith(left: 0, right: 0),
          child: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: _categories.map((category) {
                return CategoriesCategoryWidget(
                  snapshot: snapshot,
                  category: category,
                  controller: _controller,
                );
              }).toList(),
            ),
          )),
    );
  }

  Builder buildNewCategoryForm(AsyncSnapshot<SheetModel> snapshot) {
    return Builder(builder: (context) {
      return Container(
        decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
        margin: margins.content,
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
