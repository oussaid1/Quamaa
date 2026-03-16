class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.expiry,
    required this.status,
  });

  final String id;
  final String name;
  final String qty;
  final String expiry;
  final String status; // ok | low | expiring | out

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      qty: map['qty']?.toString() ?? '',
      expiry: map['expiry'] ?? '—',
      status: map['status'] ?? 'ok',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'expiry': expiry,
      'status': status,
    };
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    String? qty,
    String? expiry,
    String? status,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      expiry: expiry ?? this.expiry,
      status: status ?? this.status,
    );
  }
}
