import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Controllers
import 'package:simplebudget/ui/controllers/widgets/transaction.dart';

// Models
import 'package:simplebudget/ui/widgets/amount.dart';
import 'package:simplebudget/domain/models/transcation.dart';

// TODO Final variable defined outside of class?
final TransactionWidgetController _controller = TransactionWidgetController();

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
    Key? key,
    required this.type,
    required this.transaction,
  }) : super(key: key);

  final TransactionModel transaction;
  // 0 is income, 1 is expenditure
  final int type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings.content,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${transaction.desc},",
                  style: styles.helper,
                ),
                Text(
                  DateFormat('E, dd').format(
                    DateTime.fromMillisecondsSinceEpoch(transaction.id),
                  ),
                  style: styles.helper,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            flex: 2,
            child: AmountTextWidget(
              text: transaction.amount.toString(),
              style: styles.heading,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () =>
                  _controller.deleteTransaction(context, type, transaction),
              icon: const Icon(
                Icons.remove_circle_outline,
                color: colors.red,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
