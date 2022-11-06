import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/colors.dart';

// Widgets
import 'package:simplebudget/ui/widgets/body.dart';
import 'package:simplebudget/ui/widgets/bottom_app_bar.dart';

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    Key? key,
    required this.appBar,
    required this.title,
    required this.actions,
    required this.back,
    required this.body,
    required this.fab,
    required this.fabLocation,
  }) : super(key: key);

  final bool appBar;
  final String? title;
  final List<Widget>? actions;
  final bool? back;
  final Widget body;
  final FloatingActionButton? fab;
  final FloatingActionButtonLocation? fabLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      bottomNavigationBar: appBar == true
          ? BottomAppBarWidget(
              text: title!,
              actions: actions!,
              back: back!,
            )
          : null,
      body: BodyWidget(body: body),
      floatingActionButton: fab,
      floatingActionButtonLocation: fabLocation,
    );
  }
}
