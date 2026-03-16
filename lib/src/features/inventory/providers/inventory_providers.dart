import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/inventory_repository.dart';
import '../domain/inventory_item.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository();
});

final inventoryItemsProvider = FutureProvider<List<InventoryItem>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.fetchAll();
});
