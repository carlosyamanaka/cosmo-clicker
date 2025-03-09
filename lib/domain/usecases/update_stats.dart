import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/repositories/stats_repository.dart';

class UpdateStats {
  final StatsRepository statsRepository;

  UpdateStats(this.statsRepository);

  Future<void> call(Stats stats) async {
    await statsRepository.saveStats(stats);
  }
}
