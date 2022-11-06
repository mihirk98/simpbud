import 'package:flutter/material.dart';
import 'package:simplebudget/consts/colors.dart';

// Consts
import 'package:simplebudget/consts/strings.dart' as strings;

operationFeedback(
    Map<String, bool> status, BuildContext context, Function func) {
  if (status["decision"]!) {
    if (status["dialog"]!) {
      Navigator.of(context).pop();
    }
    if (status["success"]!) {
      func();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: secondary,
          content: Text(
            strings.operationSuccess,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: secondary,
          content: Text(
            strings.operationFailed,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

BoxDecoration widgetBox(Color color, BorderRadius radius) {
  return BoxDecoration(
    color: color,
    border: Border.all(
      color: color,
    ),
    borderRadius: radius,
  );
}
