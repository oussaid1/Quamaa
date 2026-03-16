import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/shopping_repository.dart';
import '../domain/shopping_item.dart';
import 'shopping_providers.dart';

final shoppingControllerProvider =
    AsyncNotifierProvider<ShoppingController, List<ShoppingItem>>(
      ShoppingController.new,
    );

class ShoppingController extends AsyncNotifier<List<ShoppingItem>> {
  @override
  Future<List<ShoppingItem>> build() async {
    final repo = ref.read(shoppingRepositoryProvider);
    return repo.fetchAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => ref.read(shoppingRepositoryProvider).fetchAll(),
    );
  }

  Future<void> addDemoItem() async {
    final newItem = ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'عنصر جديد',
      qty: 'x1',
      category: 'أطعمة',
      store: 'Unassigned',
      expiry: '—',
      status: 'متوفر',
      autoAdd: false,
    );

    // Optimistic update
    final current = state.value ?? [];
    state = AsyncValue.data([newItem, ...current]);

    try {
      await ref.read(shoppingRepositoryProvider).insert(newItem);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAutoAdd(String id, bool autoAdd) async {
    final current = state.value ?? [];
    final updated = current
        .map((item) => item.id == id ? item.copyWith(autoAdd: autoAdd) : item)
        .toList();
    state = AsyncValue.data(updated);

    try {
      await ref.read(shoppingRepositoryProvider).updateAutoAdd(id, autoAdd);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteItem(String id) async {
    final current = state.value ?? [];
    final updated = current.where((i) => i.id != id).toList();
    state = AsyncValue.data(updated);

    try {
      await ref.read(shoppingRepositoryProvider).delete(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
