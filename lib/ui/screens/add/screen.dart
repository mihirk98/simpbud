import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

//Blocs
import 'package:simplebudget/blocs/data.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/enums.dart' as enums;
import 'package:simplebudget/consts/margins.dart' as margins;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/radius.dart' as radius;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Controllers
import 'package:simplebudget/ui/screens/add/controller.dart';

// Models
import 'package:simplebudget/domain/models/category.dart';

// Widgets
import 'package:simplebudget/ui/widgets/skeleton/scaffold.dart';

final DataBloc _dataBloc = DataBloc();

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final AddScreenController _controller = AddScreenController();
  final _transactionFormKey = GlobalKey<FormState>();
  final _incomeTransactionFormKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final List<CategoryModel> _categories = _dataBloc.getCategories;
  bool _toggle = false;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: true,
      title: strings.add,
      actions: [
        buildValidationAction(),
      ],
      back: true,
      body: buildBody(),
      fab: null,
      fabLocation: null,
    );
  }

  IconButton buildValidationAction() {
    return IconButton(
      onPressed: buildValidationActionOnPressed,
      icon: const Icon(
        Icons.check,
        color: colors.appBarIcon,
        size: 24.0,
      ),
    );
  }

  void buildValidationActionOnPressed() async {
    if (_transactionFormKey.currentState!.validate()) {
      if (_toggle == false) {
        _controller.buildTransaction(
            context,
            enums.Action.addExpenditureTransaction,
            DateTime.now().millisecondsSinceEpoch,
            _categories[_selected].id.toString(),
            int.parse(_amountController.text));
      } else {
        if (_incomeTransactionFormKey.currentState!.validate()) {
          _controller.buildTransaction(
              context,
              enums.Action.addIncomeTransaction,
              DateTime.now().millisecondsSinceEpoch,
              _descController.text,
              int.parse(_amountController.text));
        }
      }
    }
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildNavigationTab(),
          buildNavigationBody(),
        ],
      ),
    );
  }

  Widget buildNavigationTab() {
    return Container(
      decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
      margin: margins.widget,
      child: Row(
        children: [
          buildNavigationTabExpenditure(),
          buildNavigationTabIncome(),
        ],
      ),
    );
  }

  Expanded buildNavigationTabExpenditure() {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(
          () {
            _toggle = false;
          },
        ),
        child: Container(
          alignment: Alignment.center,
          padding: paddings.content,
          decoration: utils.widgetBox(
            _toggle == false ? colors.primary : colors.widgetBackground,
            radius.widget,
          ),
          child: const Text(
            strings.expenditure,
            style: styles.heading,
          ),
        ),
      ),
    );
  }

  Expanded buildNavigationTabIncome() {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(
          () {
            _toggle = true;
          },
        ),
        child: Container(
          alignment: Alignment.center,
          padding: paddings.content,
          decoration: utils.widgetBox(
            _toggle == true ? colors.primary : colors.widgetBackground,
            radius.widget,
          ),
          child: const Text(
            strings.income,
            style: styles.heading,
          ),
        ),
      ),
    );
  }

  Widget buildNavigationBody() {
    return Container(
      decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
      margin: margins.widget,
      padding: paddings.widget,
      child: Form(
        key: _transactionFormKey,
        child: Column(
          children: [
            buildAmountTextFormField(),
            buildNavigationBodyExpenditure(),
            buildNavigationBodyIncome(),
          ],
        ),
      ),
    );
  }

  Widget buildAmountTextFormField() {
    return Padding(
      padding: paddings.content,
      // Amount TextFormField
      child: TextFormField(
        controller: _amountController,
        validator: (value) {
          if (value == null || value.isEmpty || int.parse(value) == 0) {
            return strings.validAmount;
          }
          return null;
        },
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          hintText: strings.amountHint,
        ),
        style: styles.text,
      ),
    );
  }

  Widget buildNavigationBodyExpenditure() {
    return Visibility(
      maintainState: true,
      visible: !_toggle,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          // Categories Widget
          children: List.generate(
            _categories.length,
            (index) => GestureDetector(
              onTap: () => setState(() {
                _selected = index;
              }),
              child: IntrinsicWidth(
                child: Container(
                  alignment: Alignment.center,
                  decoration: utils.widgetBox(
                    _selected == index ? colors.secondary : colors.tertiary,
                    radius.widget,
                  ),
                  padding: paddings.content,
                  margin: const EdgeInsets.all(4.0),
                  child: Text(
                    _categories[index].id,
                    style: styles.text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavigationBodyIncome() {
    return Visibility(
      maintainState: true,
      visible: _toggle,
      child: Form(
        key: _incomeTransactionFormKey,
        child: Padding(
          padding: paddings.content,
          child: TextFormField(
            controller: _descController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return strings.validDescription;
              }
              return null;
            },
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: strings.descHint,
            ),
            style: styles.text,
          ),
        ),
      ),
    );
  }
}
