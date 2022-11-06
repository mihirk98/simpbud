class TransactionModel {
  final int id;
  final String desc;
  final int amount;

  TransactionModel({
    required this.id,
    required this.desc,
    required this.amount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'],
        desc: json['desc'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        '"id"': id,
        '"desc"': "\"" + desc + "\"",
        '"amount"': amount,
      };
}
