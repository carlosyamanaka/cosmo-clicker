import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/domain/usecases/get_chests.dart';
import 'package:cosmo_clicker/domain/usecases/remove_chest.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest.dart';
import 'package:flutter/material.dart';

class ChestController extends ValueNotifier<List<Chest>> {
  final GetChests getChests;
  final SaveChest saveChest;
  final RemoveChest removeChest;

  ChestController(this.getChests, this.saveChest, this.removeChest)
      : super([]) {
    loadChests();
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
}
