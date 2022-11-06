//Consts
import 'package:simplebudget/consts/enums.dart' as enums;

class ActionModel {
  final enums.Action action;
  final Map<String, dynamic> props;

  ActionModel({
    required this.action,
    required this.props,
  });
}
