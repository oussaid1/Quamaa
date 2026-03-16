import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/shopping_repository.dart';
import '../domain/shopping_item.dart';

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepository();
});

final shoppingItemsProvider = FutureProvider<List<ShoppingItem>>((ref) {
  final repo = ref.watch(shoppingRepositoryProvider);
  return repo.fetchAll();
});
