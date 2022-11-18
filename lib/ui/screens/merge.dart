import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/strings.dart' as strings;

// Widgets
import 'package:simplebudget/ui/widgets/skeleton/scaffold.dart';

class MergeScreen extends StatelessWidget {
  const MergeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  ScaffoldWidget buildScaffold(BuildContext context) {
    return ScaffoldWidget(
        appBar: true,
        title: strings.merge,
        actions: const [],
        back: true,
        body: buildBody(context),
        fab: null,
        fabLocation: null);
  }

  Widget buildBody(BuildContext context) {
    return Container();
  }
}
