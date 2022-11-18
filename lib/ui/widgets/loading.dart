import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

class LoadingTextWidget extends StatelessWidget {
  const LoadingTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        strings.loading,
        style: styles.text,
      ),
    );
  }
}
