import '../../../core/supabase/supabase_initializer.dart';
import '../domain/budget_models.dart';

class BudgetRepository {
  Future<BudgetSummary> fetchSummary() async {
    if (!SupabaseInitializer.isReady) return _demo;

    final summaryRes = await SupabaseInitializer.client
        .from('budget_summary')
        .select()
        .maybeSingle();
    final categoriesRes = await SupabaseInitializer.client
        .from('budget_categories')
        .select();

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
