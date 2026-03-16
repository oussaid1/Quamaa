class CategorySpend {
  const CategorySpend({
    required this.label,
    required this.spent,
    required this.cap,
  });
  final String label;
  final double spent;
  final double cap;

  double get ratio => cap == 0 ? 0 : spent / cap;

  factory CategorySpend.fromMap(Map<String, dynamic> map) {
    return CategorySpend(
      label: map['label'] ?? '',
      spent: (map['spent'] as num?)?.toDouble() ?? 0,
      cap: (map['cap'] as num?)?.toDouble() ?? 0,
    );
  }
}

class StoreSpend {
  const StoreSpend({
    required this.label,
    required this.spent,
    required this.cap,
  });
  final String label;
  final double spent;
  final double cap;

  double get ratio => cap == 0 ? 0 : spent / cap;

  factory StoreSpend.fromMap(Map<String, dynamic> map) {
    return StoreSpend(
      label: map['label'] ?? '',
      spent: (map['spent'] as num?)?.toDouble() ?? 0,
      cap: (map['cap'] as num?)?.toDouble() ?? 0,
    );
  }
}

class StatsOverview {
  const StatsOverview({
    required this.remainingRatio,
    required this.remainingCaption,
    required this.categories,
    required this.stores,
  });

  final double remainingRatio;
  final String remainingCaption;
  final List<CategorySpend> categories;
  final List<StoreSpend> stores;
}
