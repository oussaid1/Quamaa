import '../../../core/supabase/supabase_initializer.dart';
import '../domain/inventory_item.dart';

class InventoryRepository {
  Future<List<InventoryItem>> fetchAll() async {
    if (!SupabaseInitializer.isReady) return _demo;
    final res = await SupabaseInitializer.client
        .from('inventory_items')
        .select();
    return (res as List<dynamic>)
        .map((row) => InventoryItem.fromMap(row as Map<String, dynamic>))
        .toList();
  }
}

const _demo = [
  InventoryItem(
    id: '1',
    name: 'حليب 2L',
    qty: 'x1',
    expiry: 'ينتهي خلال 2 يوم',
    status: 'expiring',
  ),
  InventoryItem(
    id: '2',
    name: 'بيض 12',
    qty: 'x1',
    expiry: 'ينتهي خلال 5 أيام',
    status: 'ok',
  ),
  InventoryItem(
    id: '3',
    name: 'دجاج كامل',
    qty: 'x0.5',
    expiry: 'ينتهي اليوم',
    status: 'low',
  ),
  InventoryItem(
    id: '4',
    name: 'مياه 6x1.5L',
    qty: 'x0',
    expiry: '—',
    status: 'out',
  ),
];
