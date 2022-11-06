class CategoryModel {
  final String id;
  final int budget;
  final int expenditure;

  CategoryModel({
    required this.id,
    required this.budget,
    required this.expenditure,
  });

  CategoryModel copyWith({
    String? id,
    int? budget,
    int? expenditure,
  }) {
    return CategoryModel(
        id: id ?? this.id,
        budget: budget ?? this.budget,
        expenditure: expenditure == null
            ? this.expenditure
            : this.expenditure + expenditure);
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        budget: json['budget'] ?? 0,
        expenditure: json['expenditure'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '"id"': "\"" + id + "\"",
        '"budget"': budget,
        '"expenditure"': expenditure,
      };
}
