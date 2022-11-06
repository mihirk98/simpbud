// Models
import 'package:simplebudget/domain/models/transcation.dart';

class IncomeModel {
  final List<TransactionModel> transactions;
  final int total;

  IncomeModel({
    required this.transactions,
    required this.total,
  });

  IncomeModel copyWith({
    List<TransactionModel>? transactions,
    int? total,
  }) {
    return IncomeModel(
        transactions: transactions ?? this.transactions,
        total: total == null ? this.total : this.total + total);
  }

  factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
        transactions: json['transactions'].length != 0
            ? (json['transactions'] as List)
                .map((transaction) => TransactionModel.fromJson(transaction))
                .toList()
            : [],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        '"transactions"':
            transactions.map((transaction) => transaction.toJson()).toList(),
        '"total"': total,
      };
}
