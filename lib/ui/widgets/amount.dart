import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/strings.dart' as strings;

class AmountTextWidget extends StatelessWidget {
  const AmountTextWidget({Key? key, required this.text, required this.style})
      : super(key: key);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${strings.currency} $text",
      style: style,
    );
  }
}
