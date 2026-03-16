import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/inventory_repository.dart';
import '../domain/inventory_item.dart';
import 'inventory_providers.dart';

final inventoryControllerProvider =
    AsyncNotifierProvider<InventoryController, List<InventoryItem>>(
      InventoryController.new,
    );

class InventoryController extends AsyncNotifier<List<InventoryItem>> {
  @override
  Future<List<InventoryItem>> build() async {
    return ref.read(inventoryRepositoryProvider).fetchAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(inventoryRepositoryProvider).fetchAll(),
    );
  }

  Future<void> addItem(InventoryItem item) async {
    final current = state.value ?? [];
    state = AsyncValue.data([item, ...current]);
    try {
      await ref.read(inventoryRepositoryProvider).insert(item);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> adjust(String id, String qty, String status) async {
    final current = state.value ?? [];
    state = AsyncValue.data(
      current
          .map((i) => i.id == id ? i.copyWith(qty: qty, status: status) : i)
          .toList(),
    );
    try {
      await ref.read(inventoryRepositoryProvider).adjustQty(id, qty, status);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String id) async {
    final current = state.value ?? [];
    state = AsyncValue.data(current.where((i) => i.id != id).toList());
    try {
      await ref.read(inventoryRepositoryProvider).delete(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
