import 'package:cosmo_clicker/domain/entities/upgrade.dart';

abstract class UpgradeRepository {
  Future<List<Upgrade>> getAvailableUpgrades();
  Future<void> buyUpgrade(Upgrade upgrade);
}
