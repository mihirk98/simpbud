import 'package:flutter/material.dart';

import 'package:simplebudget/ui/utils.dart' as utils;

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/radius.dart' as radius;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(borderRadius: radius.widget),
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Container(
            alignment: Alignment.center,
            decoration: utils.widgetBox(colors.widgetBackground, radius.widget),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: paddings.widget,
                  child: Text(
                    strings.confirmation,
                    style: styles.heading,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: utils.widgetBox(
                          colors.green,
                          const BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            strings.yes,
                            style: styles.text,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: utils.widgetBox(
                          colors.red,
                          const BorderRadius.only(
                            bottomRight: Radius.circular(16.0),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            strings.no,
                            style: styles.text,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
