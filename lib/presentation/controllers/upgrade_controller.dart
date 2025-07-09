import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/domain/usecases/get_available_upgrades.dart';
import 'package:cosmo_clicker/domain/usecases/buy_upgrade.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest_probability.dart';

class UpgradeController extends ValueNotifier<List<Upgrade>> {
  final GetAvailableUpgrades getAvailableUpgrades;
  final BuyUpgrade buyUpgrade;

  final DustController dustController;
  final StatsController statsController;
  final ChestController chestController;
  final SaveChestProbability saveChestProbability;

  UpgradeController(
    this.getAvailableUpgrades,
    this.buyUpgrade,
    this.dustController,
    this.statsController,
    this.chestController,
    this.saveChestProbability,
  ) : super([]) {
    _loadAvailableUpgrades();
  }

  Future<void> _loadAvailableUpgrades() async {
    final upgrades = await getAvailableUpgrades();
    value = upgrades;
  }

  Future<void> buyUpgradeItem(Upgrade upgrade) async {
    try {
      await buyUpgrade(upgrade);
      await statsController.loadStats();
      await dustController.loadDust();
      await chestController.reloadDropProbability();
      await _loadAvailableUpgrades();
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao comprar upgrade: $e');
    }
  }

  Future<void> buyUpgradeItemMultiple(Upgrade upgrade, int quantity) async {
    for (int i = 0; i < quantity; i++) {
      await buyUpgrade(upgrade);
    }
    await statsController.loadStats();
    await dustController.loadDust();
    await chestController.reloadDropProbability();
    await _loadAvailableUpgrades();
    notifyListeners();
  }
}
