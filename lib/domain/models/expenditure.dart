// Models
import 'package:simplebudget/domain/models/category.dart';
import 'package:simplebudget/domain/models/transcation.dart';

class ExpenditureModel {
  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;
  final int total;

  ExpenditureModel({
    required this.transactions,
    required this.categories,
    required this.total,
  });

  ExpenditureModel copyWith({
    List<TransactionModel>? transactions,
    List<CategoryModel>? categories,
    int? total,
  }) {
    return ExpenditureModel(
        transactions: transactions ?? this.transactions,
        categories: categories ?? this.categories,
        total: total == null ? this.total : this.total + total);
  }

  factory ExpenditureModel.fromJSON(Map<String, dynamic> json) =>
      ExpenditureModel(
        transactions: json['transactions'].length != 0
            ? (json['transactions'] as List)
                .map((transaction) => TransactionModel.fromJson(transaction))
                .toList()
            : [],
        categories: json['categories'].length != 0
            ? (json['categories'] as List)
                .map((category) => CategoryModel.fromJson(category))
                .toList()
            : [],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        '"transactions"':
            transactions.map((transaction) => transaction.toJson()).toList(),
        '"categories"':
            categories.map((category) => category.toJson()).toList(),
        '"total"': total,
      };
}
