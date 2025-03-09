import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/domain/repositories/upgrade_repository.dart';

class GetAvailableUpgrades {
  final UpgradeRepository repository;

  GetAvailableUpgrades(this.repository);

  Future<List<Upgrade>> call() async {
    return await repository.getAvailableUpgrades();
  }
}

