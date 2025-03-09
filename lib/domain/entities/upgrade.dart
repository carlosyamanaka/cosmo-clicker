import 'package:cosmo_clicker/domain/entities/stats.dart';

class Upgrade {
  final String name;
  final int cost;
  final int dustPerClickBonus;
  final int dustPerSecondBonus;

  Upgrade({
    required this.name,
    required this.cost,
    this.dustPerClickBonus = 0,
    this.dustPerSecondBonus = 0,
  });

  Stats apply(Stats currentStats) {
    return currentStats.copyWith(
      dustPerClick: currentStats.dustPerClick + dustPerClickBonus,
      dustPerSecond: currentStats.dustPerSecond + dustPerSecondBonus,
    );
  }
}
