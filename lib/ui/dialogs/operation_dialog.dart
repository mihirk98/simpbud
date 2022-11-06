import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;

class OperationDialog extends StatelessWidget {
  const OperationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 100.0,
        color: colors.dialogBackground,
        child: const CircularProgressIndicator(
          color: colors.secondary,
        ),
      ),
    );
  }
}
