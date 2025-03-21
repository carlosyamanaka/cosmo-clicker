import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/domain/usecases/get_available_upgrades.dart';
import 'package:cosmo_clicker/domain/usecases/buy_upgrade.dart';

class UpgradeController extends ValueNotifier<List<Upgrade>> {
  final GetAvailableUpgrades getAvailableUpgrades;
  final BuyUpgrade buyUpgrade;

  final DustController dustController;
  final StatsController statsController;

  UpgradeController(
    this.getAvailableUpgrades,
    this.buyUpgrade,
    this.dustController,
    this.statsController,
  ) : super([]) {
    _loadAvailableUpgrades();
  }

  Future<void> _loadAvailableUpgrades() async {
    final upgrades = await getAvailableUpgrades();
    value = upgrades;
  }

  Future<void> buyUpgradeItem(Upgrade upgrade) async {
    try {
      if (dustController.value >= upgrade.cost) {
        statsController.upgradeDustPerClick(upgrade.dustPerClickBonus);
        statsController.upgradeDustPerSecond(upgrade.dustPerSecondBonus);

        dustController.removeDust(upgrade.cost);
      } else {
        throw Exception('Poeira Estelar insuficiente!');
      }

      await buyUpgrade(upgrade);
      _loadAvailableUpgrades();
    } catch (e) {
      throw Exception('Erro ao comprar upgrade: $e');
    }
  }
}
