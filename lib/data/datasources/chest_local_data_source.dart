import 'dart:convert';

import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChestLocalDataSource {
  Future<List<Chest>> getChests();
  Future<void> saveChest(Chest chest);
  Future<void> removeChest(Chest chest);
}

class ChestLocalDataSourceImpl implements ChestLocalDataSource {
  static const _key = 'chest';

  @override
  Future<List<Chest>> getChests() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> chestsJson = prefs.getStringList(_key) ?? [];
    return chestsJson.map((json) => Chest.fromJson(jsonDecode(json))).toList();
  }

  @override
  Future<void> saveChest(Chest chest) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> chestsJson = prefs.getStringList(_key) ?? [];
    chestsJson.add(jsonEncode(chest.toJson()));
    await prefs.setStringList(_key, chestsJson);
  }

  @override
  Future<void> removeChest(Chest chest) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> chestsJson = prefs.getStringList(_key) ?? [];

    final updatedChestsJson = chestsJson.where((json) {
      final chest = Chest.fromJson(jsonDecode(json));
      return chest != chest;
    }).toList();

    await prefs.setStringList(_key, updatedChestsJson);
  }
}
