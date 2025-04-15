import 'package:cosmo_clicker/data/datasources/dust_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/stats_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/upgrade_local_data_source.dart';
import '../../domain/entities/upgrade.dart';
import '../../domain/repositories/upgrade_repository.dart';

class UpgradeRepositoryImpl implements UpgradeRepository {
  final UpgradeLocalDataSource localDataSource;
  final StatsLocalDataSource statsDataSource;
  final DustLocalDataSource dustDataSource;

  UpgradeRepositoryImpl(
      this.localDataSource, this.statsDataSource, this.dustDataSource);

  final List<Upgrade> _availableUpgrades = [
    Upgrade(
        name: "Supernova",
        description: "Aumenta a quantidade de Dust gerada por click em um",
        cost: 10,
        dustPerClickBonus: 1),
    Upgrade(
        name: "Tesouro Estelar",
        description:
            "Melhora sua chance de ganhar tesouros clicando nas estrelas",
        cost: 10,
        chestChanceBonus: 1),
  ];

  @override
  Future<List<Upgrade>> getAvailableUpgrades() async {
    return _availableUpgrades;
  }

  @override
  Future<void> buyUpgrade(Upgrade upgrade) async {
    final stats = await statsDataSource.getStats();
    final dust = await dustDataSource.getDust();

    if (dust >= upgrade.cost) {
      final updatedStats = stats.copyWith(
        dustPerClick: stats.dustPerClick + upgrade.dustPerClickBonus,
      );
      statsDataSource.saveStats(updatedStats);

      final updatedDust = dust - upgrade.cost;
      dustDataSource.saveDust(updatedDust);

      await localDataSource.buyUpgrade(upgrade);
    } else {
      throw Exception('Poeira Estelar insuficiente!');
    }
  }
}
