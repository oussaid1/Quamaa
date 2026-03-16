class BudgetCategory {
  const BudgetCategory({
    required this.name,
    required this.spent,
    required this.cap,
  });

  final String name;
  final double spent;
  final double cap;

  factory BudgetCategory.fromMap(Map<String, dynamic> map) {
    return BudgetCategory(
      name: map['name'] ?? '',
      spent: (map['spent'] as num?)?.toDouble() ?? 0,
      cap: (map['cap'] as num?)?.toDouble() ?? 0,
    );
  }

  BudgetCategory copyWith({String? name, double? spent, double? cap}) {
    return BudgetCategory(
      name: name ?? this.name,
      spent: spent ?? this.spent,
      cap: cap ?? this.cap,
    );
  }
}

class BudgetSummary {
  const BudgetSummary({
    required this.monthlyCap,
    required this.spent,
    required this.categories,
  });

  final double monthlyCap;
  final double spent;
  final List<BudgetCategory> categories;

  double get remaining => monthlyCap - spent;
  double get ratio => monthlyCap == 0 ? 0 : spent / monthlyCap;

  BudgetSummary copyWith({
    double? monthlyCap,
    double? spent,
    List<BudgetCategory>? categories,
  }) {
    return BudgetSummary(
      monthlyCap: monthlyCap ?? this.monthlyCap,
      spent: spent ?? this.spent,
      categories: categories ?? this.categories,
    );
  }
}
