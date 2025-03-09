import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/domain/repositories/upgrade_repository.dart';

class BuyUpgrade {
  final UpgradeRepository repository;

  BuyUpgrade(this.repository);

  Future<void> call(Upgrade upgrade) async {
    await repository.buyUpgrade(upgrade);
  }
}
