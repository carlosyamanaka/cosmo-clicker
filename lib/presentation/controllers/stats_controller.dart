import 'package:cosmo_clicker/domain/entities/stats.dart';
import 'package:cosmo_clicker/domain/usecases/get_stats.dart';
import 'package:cosmo_clicker/domain/usecases/update_stats.dart';
import 'package:flutter/material.dart';

class StatsController extends ValueNotifier<Stats> {
  final GetStats getStats;
  final UpdateStats updateStats;

  StatsController(this.getStats, this.updateStats) : super(Stats(dustPerClick: 1, dustPerSecond: 0)) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await getStats();
    value = stats;
  }

  Future<void> upgradeDustPerClick() async {
    final updatedStats = value.copyWith(dustPerClick: value.dustPerClick + 1);
    value = updatedStats;
    await updateStats(updatedStats);
  }

  Future<void> upgradeDustPerSecond() async {
    final updatedStats = value.copyWith(dustPerSecond: value.dustPerSecond + 1);
    value = updatedStats;
    await updateStats(updatedStats);
  }
}
