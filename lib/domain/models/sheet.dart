// Models
import 'package:simplebudget/domain/models/expenditure.dart';
import 'package:simplebudget/domain/models/income.dart';

class SheetModel {
  final ExpenditureModel expenditure;
  final IncomeModel income;

  SheetModel({required this.expenditure, required this.income});

  SheetModel copyWith({
    ExpenditureModel? expenditure,
    IncomeModel? income,
  }) {
    return SheetModel(
        expenditure: expenditure ?? this.expenditure,
        income: income ?? this.income);
  }

  factory SheetModel.fromJson(Map<String, dynamic> json) => SheetModel(
        expenditure: ExpenditureModel.fromJSON(json['expenditure']),
        income: IncomeModel.fromJson(json['income']),
      );

  Map<String, dynamic> toJson() => {
        '"expenditure"': expenditure.toJson(),
        '"income"': income.toJson(),
      };
}
