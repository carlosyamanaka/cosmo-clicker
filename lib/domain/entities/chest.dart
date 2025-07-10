import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

enum ChestRarity {
  common(
    'Comum',
    Duration(seconds: 30),
    Image(
      image: AssetImage(AppAssets.commonChest),
      height: 100,
      fit: BoxFit.contain,
    ),
  ),
  rare(
    'Raro',
    Duration(minutes: 1),
    Image(
      image: AssetImage(AppAssets.rareChest),
      height: 100,
      fit: BoxFit.contain,
    ),
  ),
  stellar(
    'Estelar',
    Duration(minutes: 5),
    Image(
      image: AssetImage(AppAssets.stellarChest),
      height: 100,
      fit: BoxFit.contain,
    ),
  ),
  boss(
    'Boss',
    Duration(minutes: 15),
    Image(
      image: AssetImage(AppAssets.bossChest),
      height: 105,
      fit: BoxFit.contain,
    ),
  );

  final String label;
  final Duration openDelay;
  final Image image;

  const ChestRarity(this.label, this.openDelay, this.image);
}

class Chest {
  final DateTime dropDate;
  final DateTime openDate;
  final ChestRarity rarity;

  Chest({
    required this.dropDate,
    required this.rarity,
  }) : openDate = dropDate.add(rarity.openDelay);

  Map<String, dynamic> toJson() {
    return {
      'dropDate': dropDate.toIso8601String(),
      'openDate': openDate.toIso8601String(),
      'rarity': rarity.name,
    };
  }

  factory Chest.fromJson(Map<String, dynamic> json) {
    final rarity = ChestRarity.values.byName(json['rarity']);
    final dropDate = DateTime.parse(json['dropDate']);
    return Chest(
      dropDate: dropDate,
      rarity: rarity,
    );
  }
}
