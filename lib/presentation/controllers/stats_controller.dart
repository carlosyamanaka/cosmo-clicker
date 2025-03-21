import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/usecases/get_stats.dart';
import 'package:cosmo_clicker/domain/usecases/update_stats.dart';
import 'package:flutter/material.dart';

class StatsController extends ValueNotifier<Stats> {
  final GetStats getStats;
  final UpdateStats updateStats;

  StatsController(this.getStats, this.updateStats)
      : super(Stats(dustPerClick: 1, dustPerSecond: 0)) {
    loadStats();
  }

  Future<void> loadStats() async {
    final stats = await getStats();
    print(stats);
    value = stats;
  }

  Future<void> upgradeDustPerClick(int amount) async {
    final updatedStats =
        value.copyWith(dustPerClick: value.dustPerClick + amount);
    value = updatedStats;
    notifyListeners();
    await updateStats(updatedStats);
  }

  Future<void> upgradeDustPerSecond(int amount) async {
    final updatedStats =
        value.copyWith(dustPerSecond: value.dustPerSecond + amount);
    value = updatedStats;
    notifyListeners();
    await updateStats(updatedStats);
  }
}
