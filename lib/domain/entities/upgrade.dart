import 'package:cosmo_clicker/domain/entities/stats.dart';

class Upgrade {
  final String name;
  final String description;
  final int cost;
  final int dustPerClickBonus;
  final int dustPerSecondBonus;

  Upgrade({
    required this.name,
    this.description = "",
    required this.cost,
    this.dustPerClickBonus = 0,
    this.dustPerSecondBonus = 0,
  });

  Stats apply(Stats currentStats) {
    return currentStats.copyWith(
      dustPerClick: currentStats.dustPerClick + dustPerClickBonus,
    );
  }
}
