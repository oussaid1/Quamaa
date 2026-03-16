import '../../../core/supabase/supabase_initializer.dart';
import '../domain/store_quota.dart';

class StoresRepository {
  Future<List<StoreQuota>> fetchAll() async {
    if (!SupabaseInitializer.isReady) return _demo;
    final res = await SupabaseInitializer.client.from('store_quotas').select();
    return (res as List<dynamic>)
        .map((row) => StoreQuota.fromMap(row as Map<String, dynamic>))
        .toList();
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
