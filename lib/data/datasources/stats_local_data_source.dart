import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StatsLocalDataSource {
  Future<void> saveStats(Stats stats);
  Future<Stats> getStats();
}

class StatsLocalDataSourceImpl implements StatsLocalDataSource {
  static const _dustPerClickKey = 'dustPerClick';
  static const _autoClickActiveKey = 'autoClickActive';

  @override
  Future<void> saveStats(Stats stats) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_dustPerClickKey, stats.dustPerClick);
    prefs.setBool(_autoClickActiveKey, stats.autoClickActive);
  }

  @override
  Future<Stats> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final int dustPerClick = prefs.getInt(_dustPerClickKey) ?? 1;
    final bool autoClickActive = prefs.getBool(_autoClickActiveKey) ?? false;

    return Stats(
      dustPerClick: dustPerClick,
      autoClickActive: autoClickActive,
    );
  }
}
