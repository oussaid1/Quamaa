import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/stores_repository.dart';
import '../domain/store_quota.dart';
import 'stores_providers.dart';

final storesControllerProvider =
    AsyncNotifierProvider<StoresController, List<StoreQuota>>(
      StoresController.new,
    );

class StoresController extends AsyncNotifier<List<StoreQuota>> {
  @override
  Future<List<StoreQuota>> build() async {
    return ref.read(storesRepositoryProvider).fetchAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(storesRepositoryProvider).fetchAll(),
    );
  }

  Future<void> addPayment(String storeId, double amount) async {
    final current = state.value ?? [];
    state = AsyncValue.data(
      current
          .map(
            (s) => s.id == storeId
                ? s.copyWith(
                    spent: (s.spent - amount).clamp(0, double.infinity),
                  )
                : s,
          )
          .toList(),
    );
    try {
      await ref
          .read(storesRepositoryProvider)
          .addPayment(storeId: storeId, amount: amount);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
