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
      if (_chestsSinceLastBoss >= 25) {
        rarity = ChestRarity.boss;
        _chestsSinceLastBoss = 0;
        await saveChestCounter(_chestsSinceLastBoss);
      } else {
        rarity = _getRandomRarity();
      }
      final chest = Chest(
        dropDate: DateTime.now(),
        openDate: DateTime.now(),
        rarity: rarity,
      );
      await addChest(chest);
    }
  }
}
