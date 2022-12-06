import 'package:flutter/material.dart';

// Consts
import 'package:simplebudget/consts/enums.dart' as enums;
import 'package:simplebudget/ui/screens/add/screen.dart';

// Screens
import 'package:simplebudget/ui/screens/calendar.dart';
import 'package:simplebudget/ui/screens/categories/screen.dart';
import 'package:simplebudget/ui/screens/home/screen.dart';
import 'package:simplebudget/ui/screens/merge.dart';

class NavigationBloc {
  // Singleton
  static final NavigationBloc _navigationBlocSingleton =
      NavigationBloc._internal();

  factory NavigationBloc() {
    return _navigationBlocSingleton;
  }

  NavigationBloc._internal();

  // Navigation
  navigateTo(enums.Navigation navigation, BuildContext context) {
    Widget navigate;
    switch (navigation) {
      case enums.Navigation.home:
        navigate = const HomeScreen();
        break;
      case enums.Navigation.calendar:
        navigate = const CalendarScreen();
        break;
      case enums.Navigation.add:
        navigate = const AddScreen();
        break;
      case enums.Navigation.categories:
        navigate = const CategoriesScreen();
        break;
      case enums.Navigation.merge:
        navigate = const MergeScreen();
        break;
    }
    if (navigation == enums.Navigation.home) {
      _pushAndRemoveUntilPageRoute(navigate, context);
    } else {
      _pushPageRoute(navigate, context);
    }
  }

  _pushAndRemoveUntilPageRoute(Widget navigate, BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => navigate),
      (Route<dynamic> route) => false,
    );
  }

  _pushPageRoute(Widget navigate, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => navigate),
    );
  }
}
