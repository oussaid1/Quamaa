import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/budget_repository.dart';
import '../domain/budget_models.dart';
import 'budget_providers.dart';

final budgetControllerProvider =
    AsyncNotifierProvider<BudgetController, BudgetSummary>(
      BudgetController.new,
    );

class BudgetController extends AsyncNotifier<BudgetSummary> {
  @override
  Future<BudgetSummary> build() async {
    return ref.read(budgetRepositoryProvider).fetchSummary();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(budgetRepositoryProvider).fetchSummary(),
    );
  }

  Future<void> addPayment(double amount, String category) async {
    final current = state.value;
    if (current != null) {
      final updatedCats = current.categories
          .map(
            (c) => c.name == category ? c.copyWith(spent: c.spent + amount) : c,
          )
          .toList();
      final newSummary = current.copyWith(
        spent: current.spent + amount,
        categories: updatedCats,
      );
      state = AsyncValue.data(newSummary);
    }
    try {
      await ref
          .read(budgetRepositoryProvider)
          .addPayment(amount: amount, category: category);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
