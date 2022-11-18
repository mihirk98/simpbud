import 'package:flutter/material.dart';

// Blocs
import 'package:simplebudget/blocs/data.dart';
import 'package:simplebudget/blocs/navigation.dart';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Models
import 'package:simplebudget/domain/models/sheet.dart';

// Widgets
import 'package:simplebudget/ui/widgets/skeleton/scaffold.dart';

final DataBloc _dataBloc = DataBloc();
final NavigationBloc _navigationBloc = NavigationBloc();

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        appBar: false,
        title: null,
        actions: null,
        back: null,
        body: buildBody(context),
        fab: null,
        fabLocation: null);
  }

  Widget buildBody(BuildContext screenContext) => Center(
        child: StreamBuilder<SheetModel>(
            stream: _dataBloc.activeSheetStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance?.addPostFrameCallback(
                  (_) => _navigationBloc.navigateTo(
                    enums.Navigation.home,
                    screenContext,
                  ),
                );
              }
              return Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: const Text(
                  strings.app,
                  style: styles.title,
                ),
              );
            }),
      );
}
