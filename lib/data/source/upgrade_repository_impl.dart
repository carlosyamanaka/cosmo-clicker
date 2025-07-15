import 'package:cosmo_clicker/core/constants/app_assets.dart';
import 'package:cosmo_clicker/data/datasources/dust_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/stats_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/upgrade_local_data_source.dart';
import '../../domain/entities/upgrade.dart';
import '../../domain/repositories/upgrade_repository.dart';
import '../../domain/usecases/get_chest_probability.dart';
import '../../domain/usecases/save_chest_probability.dart';

class UpgradeRepositoryImpl implements UpgradeRepository {
  final UpgradeLocalDataSource localDataSource;
  final StatsLocalDataSource statsDataSource;
  final DustLocalDataSource dustDataSource;
  final SaveChestProbability saveChestProbability;
  final GetChestProbability getChestProbability;

  UpgradeRepositoryImpl(
    this.localDataSource,
    this.statsDataSource,
    this.dustDataSource,
    this.saveChestProbability,
    this.getChestProbability,
  );

  final List<Upgrade> _availableUpgrades = [
    Upgrade(
      name: "Núcleos de estrelas",
      description: "Aumenta a quantidade de fragmento estelar gerada por click",
      baseCost: 50,
      imagePath: AppAssets.smallBlackballSprite,
      growthFactor: 1.2,
      level: 1,
      dustPerClickBonus: 1,
    ),
    Upgrade(
      name: "Tesouro Estelar",
      description:
          "Melhora sua chance de ganhar tesouros clicando nas estrelas",
      baseCost: 1000,
      imagePath: AppAssets.stellarTreasureChestSprite,
      growthFactor: 2.0,
      level: 1,
      chestChanceBonus: 1,
    ),
  ];

  @override
  Future<List<Upgrade>> getAvailableUpgrades() async {
    for (var i = 0; i < _availableUpgrades.length; i++) {
      final savedLevel =
          await localDataSource.getUpgradeLevel(_availableUpgrades[i].name);
      _availableUpgrades[i] = _availableUpgrades[i].copyWith(level: savedLevel);
    }
    return _availableUpgrades;
  }

  @override
  Future<void> buyUpgrade(Upgrade upgrade) async {
    final stats = await statsDataSource.getStats();
    final dust = await dustDataSource.getDust();

    final index = _availableUpgrades.indexWhere((u) => u.name == upgrade.name);
    final currentUpgrade = _availableUpgrades[index];

    if (dust >= currentUpgrade.cost) {
      final updatedStats = stats.copyWith(
        dustPerClick: stats.dustPerClick + currentUpgrade.dustPerClickBonus,
      );
      statsDataSource.saveStats(updatedStats);

      final updatedDust = dust - currentUpgrade.cost;
      dustDataSource.saveDust(updatedDust);

      if (currentUpgrade.chestChanceBonus > 0) {
        final currentProb = await getChestProbability();
        final newProb = currentProb + (currentUpgrade.chestChanceBonus / 100.0);
        await saveChestProbability(newProb);
      }

      _availableUpgrades[index] =
          currentUpgrade.copyWith(level: currentUpgrade.level + 1);

      await localDataSource.buyUpgrade(_availableUpgrades[index]);
    } else {
      throw Exception('Poeira Estelar insuficiente!');
    }
  }
}
