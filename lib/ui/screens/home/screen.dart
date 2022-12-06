import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

// Models
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/sheet.dart';
import 'package:simplebudget/domain/models/sheets.dart';
import 'package:simplebudget/domain/models/transcation.dart';

// Widgets
import 'package:simplebudget/ui/widgets/amount.dart';
import 'package:simplebudget/ui/screens/home/widget/category.dart';
import 'package:simplebudget/ui/widgets/loading.dart';
import 'package:simplebudget/ui/widgets/empty_transactions.dart';
import 'package:simplebudget/ui/widgets/skeleton/scaffold.dart';
import 'package:simplebudget/ui/widgets/transaction/widget.dart';

final DataBloc _dataBloc = DataBloc();
final NavigationBloc _navigationBloc = NavigationBloc();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  ScaffoldWidget buildScaffold(BuildContext context) {
    return ScaffoldWidget(
      appBar: true,
      title: DateFormat.MMMM().format(
        DateTime(0, _dataBloc.getMonth),
      ),
      actions: [
        IconButton(
          onPressed: () =>
              _navigationBloc.navigateTo(enums.Navigation.calendar, context),
          icon: const Icon(
            Icons.calendar_today_rounded,
            color: colors.appBarIcon,
            size: 24.0,
          ),
        ),
      ],
      back: false,
      body: const HomeBodyWidget(),
      fab: buildFab(context),
      fabLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  FloatingActionButton buildFab(BuildContext context) => FloatingActionButton(
        onPressed: () =>
            _navigationBloc.navigateTo(enums.Navigation.add, context),
        child: const Icon(
          Icons.add,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: radius.widget,
        ),
      );
}

class HomeBodyWidget extends StatefulWidget {
  const HomeBodyWidget({Key? key}) : super(key: key);

  @override
  State<HomeBodyWidget> createState() => _HomeBodyWidgetState();
}

class _HomeBodyWidgetState extends State<HomeBodyWidget> {
  bool _expenditureToggle = false;
  late SheetModel _activeSheet;
  int _totalExpenditure = 0;
  int _expectedExpenditure = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<SheetModel>(
        stream: _dataBloc.activeSheetStream,
        initialData: _dataBloc.getActiveSheet,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _activeSheet = snapshot.data!;
            return Column(
              children: [
                buildBannerWidget(),
                buildExpenditureWidget(),
                buildIncomeWidget(),
                // To prevent overlap of FAB and TransactionWidget Delete IconButton
                const SizedBox(
                  height: 80.0,
                ),
              ],
            );
          }
          return const LoadingTextWidget();
        },
      ),
    );
  }

  // ----------------------------------------------------------------------------------------------------
  // Banner Widget
  // ----------------------------------------------------------------------------------------------------
  Widget buildBannerWidget() {
    List<SheetsModel> _sheets = _dataBloc.getSheets;
    int _netTotal = 0;
    int _remainingExpenditure = 0;
    _totalExpenditure = 0;
    _expectedExpenditure = 0;
    for (SheetsModel sheets in _sheets) {
      for (SheetModel sheet in sheets.sheets) {
        _netTotal += sheet.income.total - sheet.expenditure.total;
      }
    }
    for (CategoryModel category in _activeSheet.expenditure.categories) {
      _totalExpenditure += category.expenditure;
      _expectedExpenditure += category.budget;
      if (category.expenditure < category.budget) {
        _remainingExpenditure += category.budget - category.expenditure;
      }
    }
    return Container(
      margin: margins.widget,
      child: Column(
        children: [
          Container(
            decoration: utils.widgetBox(colors.primary, radius.widget),
            margin: margins.content,
            padding: paddings.widget,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  strings.monthNet,
                  style: styles.helper,
                ),
                Align(
                  alignment: Alignment.center,
                  child: AmountTextWidget(
                    text: (_activeSheet.income.total -
                            _activeSheet.expenditure.total)
                        .toString(),
                    style: styles.banner,
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: utils.widgetBox(colors.primary, radius.widget),
                    margin: margins.content,
                    padding: paddings.widget,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          strings.totalNet,
                          style: styles.helper,
                        ),
                        AmountTextWidget(
                          text: _netTotal.toString(),
                          style: styles.heading,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: utils.widgetBox(colors.primary, radius.widget),
                    margin: margins.content,
                    padding: paddings.widget,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          strings.remainingExpenditure,
                          style: styles.helper,
                        ),
                        AmountTextWidget(
                          text: _remainingExpenditure.toString(),
                          style: styles.heading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------------------------------
  // Expenditure Widget
  // ----------------------------------------------------------------------------------------------------
  Widget buildExpenditureWidget() {
    return Container(
      decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
      margin: margins.widget,
      padding: paddings.content,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildExpenditureWidgetHeader(),
          buildExpenditureWidgetTransactions(),
        ],
      ),
    );
  }

  Row buildExpenditureWidgetHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => {
            setState(() {
              _expenditureToggle = !_expenditureToggle;
            }),
          },
          icon: const Icon(
            Icons.swap_horiz,
            size: 24,
            color: colors.text,
          ),
        ),
        const Expanded(
          child: Text(
            strings.expenditure,
            style: styles.heading,
          ),
        ),
        _expenditureToggle == false
            ? IconButton(
                onPressed: () => _navigationBloc.navigateTo(
                    enums.Navigation.categories, context),
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                  color: colors.text,
                ),
              )
            : Container(),
      ],
    );
  }

  Column buildExpenditureWidgetTransactions() {
    return Column(
      children: [
        buildTransactions(
            _activeSheet.expenditure.transactions.reversed.toList(), null),
        buildCategories(),
      ],
    );
  }

  // ----------------------------------------------------------------------------------------------------
  // Categories Widget
  // ----------------------------------------------------------------------------------------------------
  Widget buildCategories() {
    List<CategoryModel> _categories = _activeSheet.expenditure.categories;
    return Visibility(
      maintainState: true,
      visible: !_expenditureToggle,
      child: Container(
        padding: paddings.widget,
        child: Column(
          children: [
            HomeCategoryWidget(
              category: CategoryModel(
                id: "Total / Expected",
                budget: _expectedExpenditure,
                expenditure: _totalExpenditure,
              ),
            ),
            for (CategoryModel category in _categories)
              HomeCategoryWidget(
                category: category,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildIncomeWidget() {
    return Container(
      decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
      margin: margins.widget,
      padding: paddings.content,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: paddings.widget,
                child: const Text(
                  strings.income,
                  style: styles.heading,
                ),
              ),
              buildTransactions(
                  _activeSheet.income.transactions.reversed.toList(), true),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTransactions(
      List<TransactionModel> transactions, bool? visbility) {
    return Visibility(
      maintainState: true,
      visible: visbility ?? _expenditureToggle,
      child: Container(
        padding: paddings.widget,
        child: transactions.isEmpty
            ? const NoTransactionsWidget()
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transactions.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: colors.tertiary,
                ),
                itemBuilder: (BuildContext context, int index) {
                  TransactionModel transaction = transactions[index];
                  return TransactionWidget(
                    // 0 is income, 1 is expenditure
                    type: visbility != null ? 0 : 1,
                    transaction: transaction,
                  );
                },
              ),
      ),
    );
  }
}
