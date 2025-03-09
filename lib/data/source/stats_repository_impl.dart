import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/repositories/stats_repository.dart';
import 'package:cosmo_clicker/data/datasources/stats_local_data_source.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsLocalDataSource localDataSource;

  StatsRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveStats(Stats stats) async {
    return await localDataSource.saveStats(stats);
  }

  @override
  Future<Stats> getStats() async {
    final stats = await localDataSource.getStats();
    return stats;
  }
}
