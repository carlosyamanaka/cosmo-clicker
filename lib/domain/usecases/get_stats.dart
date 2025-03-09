import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/repositories/stats_repository.dart';

class GetStats {
  final StatsRepository statsRepository;

  GetStats(this.statsRepository);

  Future<Stats> call() async {
    return await statsRepository.getStats();
  }
}
