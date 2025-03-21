import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/usecases/get_stats.dart';
import 'package:cosmo_clicker/domain/usecases/update_stats.dart';
import 'package:flutter/material.dart';

class StatsController extends ValueNotifier<Stats> {
  final GetStats getStats;
  final UpdateStats updateStats;

  StatsController(this.getStats, this.updateStats)
      : super(Stats(dustPerClick: 1, autoClickActive: false)) {
    loadStats();
  }

  Future<void> loadStats() async {
    final stats = await getStats();
    value = stats;
  }

  Future<void> upgradeDustPerClick(int amount) async {
    final updatedStats =
        value.copyWith(dustPerClick: value.dustPerClick + amount);
    value = updatedStats;
    notifyListeners();
    await updateStats(updatedStats);
  }
}
