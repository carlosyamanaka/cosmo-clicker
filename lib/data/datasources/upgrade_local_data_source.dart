import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UpgradeLocalDataSource {
  Future<void> saveStats(Stats stats);
  Future<void> buyUpgrade(Upgrade upgrade);
  Future<int> getUpgradeLevel(String upgradeName);
}

class UpgradeLocalDataSourceImpl implements UpgradeLocalDataSource {
  static const _dustPerClickKey = 'dustPerClick';
  static const _dustPerSecondKey = 'dustPerSecond';

  @override
  Future<void> saveStats(stats) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_dustPerClickKey, stats.dustPerClick);
    prefs.setBool(_dustPerSecondKey, stats.autoClickActive);
  }

  @override
  Future<void> buyUpgrade(Upgrade upgrade) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('upgrade_${upgrade.name}_level', upgrade.level);
  }

  @override
  Future<int> getUpgradeLevel(String upgradeName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('upgrade_${upgradeName}_level') ?? 1;
  }
}
