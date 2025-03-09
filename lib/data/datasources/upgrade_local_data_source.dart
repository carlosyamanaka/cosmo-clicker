import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UpgradeLocalDataSource {
  Future<void> saveStats(Stats stats);
  Future<void> buyUpgrade(Upgrade upgrade);
}

class UpgradeLocalDataSourceImpl implements UpgradeLocalDataSource {
  static const _dustPerClickKey = 'dustPerClick';
  static const _dustPerSecondKey = 'dustPerSecond';

  static const _key = 'upgrade';

  @override
  Future<void> saveStats(stats) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_dustPerClickKey, stats.dustPerClick);
    prefs.setInt(_dustPerSecondKey, stats.dustPerSecond);
  }

  @override
  Future<void> buyUpgrade(upgrade) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, upgrade.name);
  }
}
