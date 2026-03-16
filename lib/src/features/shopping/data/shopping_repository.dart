import '../../../core/supabase/supabase_initializer.dart';
import '../domain/shopping_item.dart';

class ShoppingRepository {
  /// Fetch shopping items. Falls back to demo data if Supabase isn't ready.
  Future<List<ShoppingItem>> fetchAll() async {
    if (!SupabaseInitializer.isReady) return _demoItems;

    final user = SupabaseInitializer.client.auth.currentUser;
    final query = SupabaseInitializer.client.from('shopping_items').select();
    final res = user == null ? await query : await query.eq('user_id', user.id);
    return (res as List<dynamic>)
        .map((row) => ShoppingItem.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> insert(ShoppingItem item) async {
    if (!SupabaseInitializer.isReady) return;
    final user = SupabaseInitializer.client.auth.currentUser;
    await SupabaseInitializer.client.from('shopping_items').insert({
      ...item.toMap(),
      if (user != null) 'user_id': user.id,
    });
  }

  Future<void> updateAutoAdd(String id, bool autoAdd) async {
    if (!SupabaseInitializer.isReady) return;
    await SupabaseInitializer.client
        .from('shopping_items')
        .update({'auto_add': autoAdd})
        .eq('id', id);
  }

  Future<void> delete(String id) async {
    if (!SupabaseInitializer.isReady) return;
    await SupabaseInitializer.client
        .from('shopping_items')
        .delete()
        .eq('id', id);
  }
}

const _demoItems = [
  ShoppingItem(
    id: '1',
    name: 'حليب 2L',
    qty: 'x2',
    category: 'أطعمة',
    store: 'كارفور',
    expiry: 'ينتهي خلال 2 يوم',
    status: 'منخفض',
    autoAdd: true,
  ),
  ShoppingItem(
    id: '2',
    name: 'بيض 12',
    qty: 'x1',
    category: 'أطعمة',
    store: 'كارفور',
    expiry: 'ينتهي خلال 4 أيام',
    status: 'متوفر',
    autoAdd: true,
  ),
  ShoppingItem(
    id: '3',
    name: 'دجاج كامل',
    qty: 'x1',
    category: 'أطعمة',
    store: 'كارفور',
    expiry: 'ينتهي خلال 1 يوم',
    status: 'منتهي قريبًا',
    autoAdd: false,
  ),
  ShoppingItem(
    id: '4',
    name: 'منظف أرضيات',
    qty: 'x1',
    category: 'تنظيف',
    store: 'بقالة الحي',
    expiry: '—',
    status: 'متوفر',
    autoAdd: false,
  ),
  ShoppingItem(
    id: '5',
    name: 'مياه 6x1.5L',
    qty: 'x1',
    category: 'مشروبات',
    store: 'بقالة الحي',
    expiry: '—',
    status: 'نفد',
    autoAdd: true,
  ),
];
