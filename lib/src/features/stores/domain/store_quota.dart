class StoreQuota {
  const StoreQuota({
    required this.id,
    required this.name,
    required this.period,
    required this.cap,
    required this.spent,
    required this.nextDue,
  });

  final String id;
  final String name;
  final String period; // daily | weekly | monthly
  final double cap;
  final double spent;
  final String nextDue;

  double get remaining => cap - spent;
  double get ratio => cap == 0 ? 0 : spent / cap;

  factory StoreQuota.fromMap(Map<String, dynamic> map) {
    return StoreQuota(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      period: map['period'] ?? 'weekly',
      cap: (map['cap'] as num?)?.toDouble() ?? 0,
      spent: (map['spent'] as num?)?.toDouble() ?? 0,
      nextDue: map['next_due']?.toString() ?? '',
    );
  }
}
