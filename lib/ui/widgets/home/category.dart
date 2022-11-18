import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Models
import 'package:simplebudget/domain/models/category.dart';

// Widgets
import 'package:simplebudget/ui/widgets/amount.dart';

class HomeCategoryWidget extends StatelessWidget {
  const HomeCategoryWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    int budget = category.budget;
    int expenditure = category.expenditure;
    int remaining = budget - expenditure;
    double percentage =
        budget != 0 && expenditure != 0 ? expenditure / budget : 0.0;
    return Padding(
      padding: paddings.content,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  category.id,
                  style: styles.helper,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  (remaining.isNegative && budget != 0
                          ? "+"
                          : budget == 0
                              ? "-"
                              : "") +
                      (remaining * -1).toString(),
                  style: styles.heading.copyWith(
                    color: remaining.isNegative && budget != 0
                        ? colors.red
                        : budget == 0 && remaining == 0
                            ? colors.green
                            : colors.blue,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Padding(
            padding: paddings.content.copyWith(bottom: 0),
            child: Wrap(
              runSpacing: 8.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                budget != 0
                    ? Container(
                        height: 4.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colors.tertiary,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: percentage > 1 ? 1.0 : percentage,
                          child: Container(
                              color: percentage < 1
                                  ? colors.blue
                                  : percentage == 1
                                      ? colors.green
                                      : colors.red),
                        ),
                      )
                    : const SizedBox(),
                budget != 0
                    ? const SizedBox(
                        width: 8.0,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: budget != 0
                ? AmountTextWidget(
                    text: expenditure.toString() + " / " + budget.toString(),
                    style: styles.helper,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
