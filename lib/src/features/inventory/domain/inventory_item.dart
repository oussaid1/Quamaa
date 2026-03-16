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
}
