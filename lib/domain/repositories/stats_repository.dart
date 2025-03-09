import 'package:cosmo_clicker/domain/entities/stats.dart';

abstract class StatsRepository {
  Future<void> saveStats(Stats stats);
  Future<Stats> getStats();
}
