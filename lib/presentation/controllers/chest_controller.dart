import 'dart:math';
import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/domain/usecases/drop_chest.dart';
import 'package:cosmo_clicker/domain/usecases/get_chests.dart';
import 'package:cosmo_clicker/domain/usecases/get_chest_counter.dart';
import 'package:cosmo_clicker/domain/usecases/remove_chest.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest_counter.dart';
import 'package:cosmo_clicker/domain/usecases/get_chest_probability.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest_probability.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:flutter/material.dart';

class ChestController extends ValueNotifier<List<Chest>> {
  final GetChests getChests;
  final SaveChest saveChest;
  final RemoveChest removeChest;
  final DropChest dropChest;
  final GetChestCounter getChestCounter;
  final SaveChestCounter saveChestCounter;
  final GetChestProbability getChestProbability;
  final SaveChestProbability saveChestProbability;
  final DustController dustController;
  final StatsController statsController;
  ValueNotifier<double> dropProbability;
  int _chestsSinceLastBoss = 0;
  final Random _random = Random();

  ChestController(
    this.getChests,
    this.saveChest,
    this.removeChest,
    this.dropChest,
    this.dropProbability,
    this.getChestCounter,
    this.saveChestCounter,
    this.getChestProbability,
    this.saveChestProbability,
    this.dustController,
    this.statsController,
  ) : super([]) {
    loadChests();
    _loadChestCounter();
    _loadDropProbability();
  }

  Future<void> loadChests() async {
    final chests = await getChests();
    value = chests;
    notifyListeners();
  }

  Future<void> addChest(Chest chest) async {
    final updatedChests = List<Chest>.from(value)..add(chest);
    value = updatedChests;
    notifyListeners();
    await saveChest(chest);
  }

  Future<void> openChest(Chest chest) async {
    final updatedChests = List<Chest>.from(value)..remove(chest);
    value = updatedChests;
    notifyListeners();
    await removeChest(chest);
  }

  Future<void> _loadChestCounter() async {
    _chestsSinceLastBoss = await getChestCounter();
  }

  Future<void> _loadDropProbability() async {
    dropProbability.value = await getChestProbability();
  }

  Future<void> reloadDropProbability() async {
    dropProbability.value = await getChestProbability();
  }

  ChestRarity _getRandomRarity() {
    final roll = _random.nextDouble();
    if (roll < 0.7) return ChestRarity.common;
    if (roll < 0.92) return ChestRarity.rare;
    return ChestRarity.stellar;
  }

  Future<void> tryDropChest() async {
    if (dropChest(dropProbability.value)) {
      ChestRarity rarity;
      _chestsSinceLastBoss++;
      await saveChestCounter(_chestsSinceLastBoss);
      if (_chestsSinceLastBoss >= 75) {
        rarity = ChestRarity.boss;
        _chestsSinceLastBoss = 0;
        await saveChestCounter(_chestsSinceLastBoss);
      } else {
        rarity = _getRandomRarity();
      }
      final chest = Chest(
        dropDate: DateTime.now(),
        rarity: rarity,
      );
      await addChest(chest);
    }
  }

  Future<int> generateChestReward(Chest chest) async {
    final random = Random();
    int dust;
    switch (chest.rarity) {
      case ChestRarity.common:
        dust = 50 + random.nextInt(51);
        break;
      case ChestRarity.rare:
        dust = 120 + random.nextInt(61);
        break;
      case ChestRarity.stellar:
        dust = 200 + random.nextInt(101);
        break;
      default:
        dust = 50;
    }
    final dustPerClick = statsController.value.dustPerClick;
    final totalDust = (dust * dustPerClick).ceil();
    await Future.delayed(const Duration(seconds: 1));
    dustController.addDust(totalDust);
    return totalDust;
  }
}
