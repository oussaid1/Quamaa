import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/budget_repository.dart';
import '../domain/budget_models.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => BudgetRepository(),
);

final budgetSummaryProvider = FutureProvider<BudgetSummary>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.fetchSummary();
});
