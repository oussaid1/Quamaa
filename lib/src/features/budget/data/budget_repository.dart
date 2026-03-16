import '../../../core/supabase/supabase_initializer.dart';
import '../domain/budget_models.dart';

class BudgetRepository {
  Future<BudgetSummary> fetchSummary() async {
    if (!SupabaseInitializer.isReady) return _demo;

    final user = SupabaseInitializer.client.auth.currentUser;
    final summaryQuery = SupabaseInitializer.client
        .from('budget_summary')
        .select()
        .maybeSingle();
    final categoriesQuery = SupabaseInitializer.client
        .from('budget_categories')
        .select();

    final summaryRes = await summaryQuery;
    final categoriesRes = user == null
        ? await categoriesQuery
        : await categoriesQuery.eq('user_id', user.id);

    final monthlyCap = (summaryRes?['monthly_cap'] as num?)?.toDouble() ?? 0;
    final spent = (summaryRes?['spent'] as num?)?.toDouble() ?? 0;
    final categories = (categoriesRes as List<dynamic>)
        .map((row) => BudgetCategory.fromMap(row as Map<String, dynamic>))
        .toList();

    return BudgetSummary(
      monthlyCap: monthlyCap,
      spent: spent,
      categories: categories,
    );
  }

  Future<void> addPayment({
    required double amount,
    required String category,
  }) async {
    if (!SupabaseInitializer.isReady) return;
    final user = SupabaseInitializer.client.auth.currentUser;
    await SupabaseInitializer.client.from('budget_payments').insert({
      'amount': amount,
      'category': category,
      if (user != null) 'user_id': user.id,
    });
  }
}

final _demo = BudgetSummary(
  monthlyCap: 3000,
  spent: 550,
  categories: const [
    BudgetCategory(name: 'أطعمة', spent: 1200, cap: 1500),
    BudgetCategory(name: 'فواتير', spent: 400, cap: 500),
    BudgetCategory(name: 'ترفيه', spent: 150, cap: 500),
  ],
);
