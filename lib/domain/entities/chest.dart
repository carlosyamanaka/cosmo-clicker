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
  final DateTime dropDate;
  final ChestRarity rarity;
  final ChestType type;

  Chest({
    required this.dropDate,
    required this.rarity,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'dropDate': dropDate.toIso8601String(),
      'rarity': rarity.name,
      'type': type.name,
    };
  }

  factory Chest.fromJson(Map<String, dynamic> json) {
    return Chest(
      dropDate: DateTime.parse(json['dropDate']),
      rarity: ChestRarity.values.byName(json['rarity']),
      type: ChestType.values.byName(json['type']),
    );
  }
}
