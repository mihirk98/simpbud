import 'package:flutter/material.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/radius.dart' as radius;

class OperationDialog extends StatelessWidget {
  const OperationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: radius.widget,
      ),
      alignment: Alignment.center,
      child: Container(
        decoration: utils.widgetBox(colors.dialogBackground, radius.widget),
        alignment: Alignment.center,
        width: 100.0,
        height: 100.0,
        child: const CircularProgressIndicator(
          color: colors.secondary,
        ),
      ),
    );
  }
}
