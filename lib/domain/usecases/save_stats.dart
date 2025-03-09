import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/repositories/stats_repository.dart';

class SaveStats {
  final StatsRepository repository;

  SaveStats(this.repository);

  Future<void> call(Stats stats) async {
    await repository.saveStats(stats);
  }
}
