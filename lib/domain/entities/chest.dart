enum ChestRarity {
  common('Comum'),
  rare('Raro'),
  stellar('Estelar');

  final String label;

  const ChestRarity(this.label);
}

enum ChestType {
  dust,
  boss;
}

class Chest {
  final DateTime openDate;
  final ChestRarity rarity;
  final ChestType type;

  Chest({
    required this.openDate,
    required this.rarity,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'openDate': openDate.toIso8601String(),
      'rarity': rarity.name,
      'type': type.name,
    };
  }

  factory Chest.fromJson(Map<String, dynamic> json) {
    return Chest(
      openDate: DateTime.parse(json['openDate']),
      rarity: ChestRarity.values.byName(json['rarity']),
      type: ChestType.values.byName(json['type']),
    );
  }
}
