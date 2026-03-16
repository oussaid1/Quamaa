import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/stores_repository.dart';
import '../domain/store_quota.dart';

final storesRepositoryProvider = Provider<StoresRepository>(
  (ref) => StoresRepository(),
);

final storesProvider = FutureProvider<List<StoreQuota>>((ref) {
  final repo = ref.watch(storesRepositoryProvider);
  return repo.fetchAll();
});
