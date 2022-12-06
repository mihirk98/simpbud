import 'package:flutter/material.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Blocs
import 'package:simplebudget/blocs/data.dart';
import 'package:simplebudget/blocs/presentation.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/enums.dart' as enums;
import 'package:simplebudget/consts/margins.dart' as margins;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/radius.dart' as radius;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Models
import 'package:simplebudget/domain/models/action.dart';
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/sheet.dart';
import 'package:simplebudget/domain/models/transcation.dart';

// Widgets
import 'package:simplebudget/ui/widgets/skeleton/scaffold.dart';
import 'package:simplebudget/ui/widgets/transaction/widget.dart';

final DataBloc _dataBloc = DataBloc();
final PresentationBloc _presentationBloc = PresentationBloc();

class MergeScreen extends StatefulWidget {
  const MergeScreen({Key? key}) : super(key: key);

  @override
  State<MergeScreen> createState() => _MergeScreenState();
}

class _MergeScreenState extends State<MergeScreen> {
  late List<CategoryModel> _catgeories;
  late int _categoriesLength = _catgeories.length;
  late CategoryModel _selectedCategory = _catgeories.first;
  late CategoryModel _migrateToCategory = _catgeories.last;

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  ScaffoldWidget buildScaffold(BuildContext context) {
    return ScaffoldWidget(
      appBar: true,
      title: strings.merge,
      actions: [buildMergeCategoriesButton(context)],
      back: true,
      body: buildBody(context),
      fab: null,
      fabLocation: null,
    );
  }

  Widget buildMergeCategoriesButton(BuildContext context) {
    return IconButton(
      onPressed: () => {
        if (_selectedCategory != _migrateToCategory)
          _presentationBloc
              .action(
                  ActionModel(
                    action: enums.Action.mergeCategories,
                    props: {
                      "category": _selectedCategory,
                      "id": _migrateToCategory.id,
                    },
                  ),
                  context)
              .then(
                (status) => utils.operationFeedback(
                  status,
                  context,
                  () => {},
                ),
              )
      },
      icon: const Icon(
        Icons.merge,
        color: colors.appBarIcon,
        size: 24.0,
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<SheetModel>(
      stream: _dataBloc.activeSheetStream,
      initialData: _dataBloc.getActiveSheet,
      builder: (context, snapshot) {
        SheetModel _sheet = snapshot.data!;
        List<TransactionModel> _transactions = _sheet.expenditure.transactions;
        _catgeories = _sheet.expenditure.categories;
        if (_categoriesLength != _catgeories.length) {
          _categoriesLength = _catgeories.length;
          _selectedCategory = _catgeories.first;
          _migrateToCategory = _catgeories.last;
        }
        List<TransactionModel> _selectedCategoryTransactions = _transactions
            .where((transaction) => transaction.desc == _selectedCategory.id)
            .toList();
        return Column(
          children: [
            Container(
              decoration:
                  utils.widgetBox(colors.widgetBackground, radius.widget),
              padding: paddings.widget,
              margin: margins.widget,
              child: buildDropDownButton(0),
            ),
            Expanded(
              child: Container(
                decoration:
                    utils.widgetBox(colors.widgetBackground, radius.widget),
                padding: paddings.widget,
                margin: margins.widget.copyWith(bottom: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedCategoryTransactions.length,
                  itemBuilder: (context, i) {
                    // 0 is income, 1 is expenditure
                    return TransactionWidget(
                        type: 1, transaction: _selectedCategoryTransactions[i]);
                  },
                ),
              ),
            ),
            Container(
              decoration:
                  utils.widgetBox(colors.widgetBackground, radius.widget),
              padding: paddings.widget,
              margin: margins.widget.copyWith(top: 0, bottom: 16.0),
              child: buildDropDownButton(1),
            ),
          ],
        );
      },
    );
  }

  Container buildDropDownButton(int binary) {
    // 0 is selected category, 1 is migrate to category
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: utils.widgetBox(colors.secondary, radius.widget),
      child: DropdownButton<CategoryModel>(
        isExpanded: true,
        value: binary == 0 ? _selectedCategory : _migrateToCategory,
        style: styles.text,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: colors.text,
          size: 28,
        ),
        underline: const SizedBox(),
        items: buildCategoryDropDownButton(),
        onChanged: (CategoryModel? selectedCategory) {
          setState(() {
            if (binary == 0) {
              _selectedCategory = selectedCategory!;
            } else {
              _migrateToCategory = selectedCategory!;
            }
          });
        },
      ),
    );
  }

  List<DropdownMenuItem<CategoryModel>> buildCategoryDropDownButton() {
    return _catgeories
        .map<DropdownMenuItem<CategoryModel>>(
          (category) => DropdownMenuItem(
            value: category,
            child: Container(
              padding: paddings.content,
              child: Text(
                category.id,
                style: styles.heading,
              ),
            ),
          ),
        )
        .toList();
  }
}
