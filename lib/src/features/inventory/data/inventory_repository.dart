import '../../../core/supabase/supabase_initializer.dart';
import '../domain/inventory_item.dart';

class InventoryRepository {
  Future<List<InventoryItem>> fetchAll() async {
    if (!SupabaseInitializer.isReady) return _demo;
    final user = SupabaseInitializer.client.auth.currentUser;
    final query = SupabaseInitializer.client.from('inventory_items').select();
    final res = user == null ? await query : await query.eq('user_id', user.id);
    return (res as List<dynamic>)
        .map((row) => InventoryItem.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> insert(InventoryItem item) async {
    if (!SupabaseInitializer.isReady) return;
    final user = SupabaseInitializer.client.auth.currentUser;
    await SupabaseInitializer.client.from('inventory_items').insert({
      ...item.toMap(),
      if (user != null) 'user_id': user.id,
    });
  }

  Future<void> adjustQty(String id, String qty, String status) async {
    if (!SupabaseInitializer.isReady) return;
    await SupabaseInitializer.client
        .from('inventory_items')
        .update({'qty': qty, 'status': status})
        .eq('id', id);
  }

  Future<void> delete(String id) async {
    if (!SupabaseInitializer.isReady) return;
    await SupabaseInitializer.client
        .from('inventory_items')
        .delete()
        .eq('id', id);
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
