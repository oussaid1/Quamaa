import '../../../core/supabase/supabase_initializer.dart';
import '../domain/stats_models.dart';

class StatsRepository {
  Future<StatsOverview> fetch() async {
    if (!SupabaseInitializer.isReady) return _demo;

    final user = SupabaseInitializer.client.auth.currentUser;
    final categoriesQuery = SupabaseInitializer.client
        .from('stats_categories')
        .select();
    final storesQuery = SupabaseInitializer.client
        .from('stats_stores')
        .select();
    final summaryQuery = SupabaseInitializer.client
        .from('stats_summary')
        .select()
        .maybeSingle();

    final summary = await summaryQuery;
    final categoriesRes = user == null
        ? await categoriesQuery
        : await categoriesQuery.eq('user_id', user.id);
    final storesRes = user == null
        ? await storesQuery
        : await storesQuery.eq('user_id', user.id);

    final categories = (categoriesRes as List<dynamic>)
        .map((row) => CategorySpend.fromMap(row as Map<String, dynamic>))
        .toList();
    final stores = (storesRes as List<dynamic>)
        .map((row) => StoreSpend.fromMap(row as Map<String, dynamic>))
        .toList();

    return StatsOverview(
      remainingRatio: (summary?['remaining_ratio'] as num?)?.toDouble() ?? 0.62,
      remainingCaption:
          summary?['remaining_caption']?.toString() ?? '2,450 / 3,000',
      categories: categories,
      stores: stores,
    );
  }
}

final _demo = StatsOverview(
  remainingRatio: 0.62,
  remainingCaption: '2,450 / 3,000',
  categories: const [
    CategorySpend(label: 'أطعمة', spent: 1200, cap: 1500),
    CategorySpend(label: 'فواتير', spent: 400, cap: 500),
    CategorySpend(label: 'ترفيه', spent: 150, cap: 500),
  ],
  stores: const [
    StoreSpend(label: 'كارفور', spent: 300, cap: 500),
    StoreSpend(label: 'بقالة الحي', spent: 120, cap: 200),
    StoreSpend(label: 'Unassigned', spent: 40, cap: 200),
  ],
);
