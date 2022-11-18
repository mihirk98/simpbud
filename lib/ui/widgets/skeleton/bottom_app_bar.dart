import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/paddings.dart' as paddings;
import 'package:simplebudget/consts/styles.dart' as styles;

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({
    Key? key,
    required this.text,
    required this.actions,
    required this.back,
  }) : super(key: key);

  final String text;
  final List<Widget> actions;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: paddings.content,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                back == true
                    ? IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: colors.appBarIcon,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : const SizedBox(),
                Text(
                  text,
                  style: styles.appBar,
                ),
              ],
            ),
            Row(
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
