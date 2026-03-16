import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/stats_repository.dart';
import '../domain/stats_models.dart';

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => StatsRepository(),
);

final statsOverviewProvider = FutureProvider<StatsOverview>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.fetch();
});
