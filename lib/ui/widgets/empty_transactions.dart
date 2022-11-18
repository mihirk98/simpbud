import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

class NoTransactionsWidget extends StatelessWidget {
  const NoTransactionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: paddings.content,
      child: const Text(
        strings.noTransactions,
        style: styles.heading,
      ),
    );
  }
}
