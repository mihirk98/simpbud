import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/colors.dart' as colors;
import 'package:simplebudget/consts/radius.dart' as radius;
import 'package:simplebudget/consts/strings.dart' as strings;
import 'package:simplebudget/consts/styles.dart' as styles;

// Screens
import 'package:simplebudget/ui/screens/splash.dart';

// TODO Support multiple currencies
// TODO Carry over categories to new month?
void main() {
  runApp(const SimpleBudgetApp());
}

class SimpleBudgetApp extends StatelessWidget {
  const SimpleBudgetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.app,
      theme: buildThemeData(context),
      home: const SplashScreen(),
    );
  }

  ThemeData buildThemeData(BuildContext context) {
    return ThemeData(
      primaryColor: colors.primary,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: colors.text,
            displayColor: colors.text,
          ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: colors.appBar,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.tertiary,
          ),
          borderRadius: radius.widget,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.secondary,
          ),
          borderRadius: radius.widget,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.secondary,
          ),
          borderRadius: radius.widget,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.red,
          ),
          borderRadius: radius.widget,
        ),
        helperStyle: styles.helper,
        hintStyle: styles.hint,
        errorStyle: styles.error,
        suffixStyle: styles.helper,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: colors.text,
        ),
      ),
      canvasColor: colors.tertiary,
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: colors.secondary),
    );
  }
}
