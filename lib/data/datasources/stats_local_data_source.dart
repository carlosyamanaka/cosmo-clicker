import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StatsLocalDataSource {
  Future<void> saveStats(Stats stats);
  Future<Stats> getStats();
}

class StatsLocalDataSourceImpl implements StatsLocalDataSource {
  static const _dustPerClickKey = 'dustPerClick';
  static const _dustPerSecondKey = 'dustPerSecond';

  @override
  Future<void> saveStats(Stats stats) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_dustPerClickKey, stats.dustPerClick);
    prefs.setInt(_dustPerSecondKey, stats.dustPerSecond);
  }

  @override
  Future<Stats> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final dustPerClick = prefs.getInt(_dustPerClickKey) ?? 1;
    final dustPerSecond = prefs.getInt(_dustPerSecondKey) ?? 0;

    return Stats(
      dustPerClick: dustPerClick,
      dustPerSecond: dustPerSecond,
    );
  }
}
