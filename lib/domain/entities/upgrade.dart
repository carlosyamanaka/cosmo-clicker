import 'dart:math';
import 'package:cosmo_clicker/domain/entities/stats.dart';

class Upgrade {
  final String name;
  final String description;
  final int baseCost;
  final String imagePath;
  final double growthFactor;
  final int level;
  final int dustPerClickBonus;
  final int dustPerSecondBonus;
  final int chestChanceBonus;

  Upgrade({
    required this.name,
    this.description = "",
    required this.baseCost,
    this.imagePath = "assets/images/stellar_treasure_chest_sprite_10x26.png",
    this.growthFactor = 1.2,
    this.level = 1,
    this.dustPerClickBonus = 0,
    this.dustPerSecondBonus = 0,
    this.chestChanceBonus = 0,
  });

  int get cost => (baseCost * pow(growthFactor, (level - 1))).round();

  Upgrade copyWith({int? level}) {
    return Upgrade(
      name: name,
      description: description,
      baseCost: baseCost,
      imagePath: imagePath,
      growthFactor: growthFactor,
      level: level ?? this.level,
      dustPerClickBonus: dustPerClickBonus,
      dustPerSecondBonus: dustPerSecondBonus,
      chestChanceBonus: chestChanceBonus,
    );
  }

  Stats apply(Stats currentStats) {
    return currentStats.copyWith(
      dustPerClick: currentStats.dustPerClick + dustPerClickBonus,
    );
  }
}
