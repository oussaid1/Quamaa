import '../../../core/supabase/supabase_initializer.dart';
import '../domain/store_quota.dart';

class StoresRepository {
  Future<List<StoreQuota>> fetchAll() async {
    if (!SupabaseInitializer.isReady) return _demo;
    final user = SupabaseInitializer.client.auth.currentUser;
    final query = SupabaseInitializer.client.from('store_quotas').select();
    final res = user == null ? await query : await query.eq('user_id', user.id);
    return (res as List<dynamic>)
        .map((row) => StoreQuota.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> addPayment({
    required String storeId,
    required double amount,
  }) async {
    if (!SupabaseInitializer.isReady) return;
    final user = SupabaseInitializer.client.auth.currentUser;
    await SupabaseInitializer.client.from('store_payments').insert({
      'store_id': storeId,
      'amount': amount,
      if (user != null) 'user_id': user.id,
    });
  }
}

const _demo = [
  StoreQuota(
    id: '1',
    name: 'كارفور',
    period: 'weekly',
    cap: 500,
    spent: 300,
    nextDue: '2026-03-20',
  ),
  StoreQuota(
    id: '2',
    name: 'بقالة الحي',
    period: 'weekly',
    cap: 200,
    spent: 120,
    nextDue: '2026-03-20',
  ),
  StoreQuota(
    id: '3',
    name: 'Unassigned',
    period: 'monthly',
    cap: 200,
    spent: 40,
    nextDue: '2026-04-01',
  ),
];
