class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.category,
    required this.store,
    required this.expiry,
    required this.status,
    required this.autoAdd,
  });

  final String id;
  final String name;
  final String qty;
  final String category;
  final String store;
  final String expiry;
  final String status;
  final bool autoAdd;

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      qty: map['qty']?.toString() ?? '',
      category: map['category'] ?? '',
      store: map['store'] ?? 'Unassigned',
      expiry: map['expiry'] ?? '—',
      status: map['status'] ?? 'متوفر',
      autoAdd: map['auto_add'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'category': category,
      'store': store,
      'expiry': expiry,
      'status': status,
      'auto_add': autoAdd,
    };
  }
}
