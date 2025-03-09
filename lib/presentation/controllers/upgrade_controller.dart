import 'package:flutter/material.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/domain/usecases/get_available_upgrades.dart';
import 'package:cosmo_clicker/domain/usecases/buy_upgrade.dart';

class UpgradeController extends ValueNotifier<List<Upgrade>> {
  final GetAvailableUpgrades getAvailableUpgrades;
  final BuyUpgrade buyUpgrade;

  UpgradeController(this.getAvailableUpgrades, this.buyUpgrade) : super([]) {
    _loadAvailableUpgrades();
  }

  Future<void> _loadAvailableUpgrades() async {
    final upgrades = await getAvailableUpgrades();
    value = upgrades;
  }

  Future<void> buyUpgradeItem(Upgrade upgrade) async {
    try {
      await buyUpgrade(upgrade);
      _loadAvailableUpgrades();
    } catch (e) {
      throw Exception('Erro ao comprar upgrade: $e');
    }
  }
}
