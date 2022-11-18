import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Blocs
import 'package:simplebudget/blocs/data.dart';
import 'package:simplebudget/blocs/navigation.dart';
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
import 'package:simplebudget/domain/models/sheet.dart';
import 'package:simplebudget/domain/models/sheets.dart';

// Widgets
import 'package:simplebudget/ui/widgets/amount.dart';
import 'package:simplebudget/ui/widgets/skeleton/scaffold.dart';

final DataBloc _dataBloc = DataBloc();
final PresentationBloc _presentationBloc = PresentationBloc();
final NavigationBloc _navigationBloc = NavigationBloc();

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SheetsModel> _sheetsModelList = _dataBloc.getSheets.reversed.toList();
    return ScaffoldWidget(
        appBar: true,
        title: strings.calendar,
        actions: const [],
        back: true,
        body: buildBody(_sheetsModelList),
        fab: null,
        fabLocation: null);
  }

  Widget buildBody(List<SheetsModel> _sheetsModelList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _sheetsModelList.length,
            itemBuilder: (BuildContext context, int index) {
              List<SheetModel> _sheetModelList = _sheetsModelList[index].sheets;
              return Container(
                decoration:
                    utils.widgetBox(colors.widgetBackground, radius.widget),
                margin: margins.widget,
                padding: paddings.widget,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _sheetsModelList[index].year.toString(),
                      style: styles.title,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _sheetModelList.length,
                      itemBuilder: (BuildContext context, int i) {
                        int net = _sheetModelList[i].income.total -
                            _sheetModelList[i].expenditure.total;
                        return GestureDetector(
                          // getActiveSheet month value is +1 because month ranges from 1 .. 12 and array values from 0 .. 11
                          onTap: () => _presentationBloc.action(
                            ActionModel(
                              action: enums.Action.setActiveSheet,
                              props: {
                                "year": _sheetsModelList[index].year,
                                "month": i + 1,
                              },
                            ),
                            context,
                          ),
                          child: Container(
                            decoration:
                                utils.widgetBox(colors.tertiary, radius.widget),
                            margin:
                                const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                            padding: paddings.widget,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AmountTextWidget(
                                  text: net.toString(),
                                  style: net > 0
                                      ? styles.heading
                                          .copyWith(color: colors.green)
                                      : net == 0
                                          ? styles.heading
                                          : styles.heading
                                              .copyWith(color: colors.red),
                                ),
                                Text(
                                  DateFormat.MMMM().format(
                                    DateTime(0, i + 1),
                                  ),
                                  style: styles.helper,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          StreamBuilder(
              stream: _dataBloc.activeSheetStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance?.addPostFrameCallback(
                    (_) => _navigationBloc.navigateTo(
                        enums.Navigation.home, context),
                  );
                }
                return const SizedBox(
                  height: 16.0,
                );
              }),
        ],
      ),
    );
  }
}
