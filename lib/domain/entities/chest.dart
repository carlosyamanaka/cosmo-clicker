enum ChestRarity {
  common('Comum'),
  rare('Raro'),
  stellar('Estelar'),
  boss('Boss');

  final String label;

  const ChestRarity(this.label);
}

class Chest {
  final DateTime dropDate;
  final DateTime openDate;
  final ChestRarity rarity;

  Chest({
    required this.dropDate,
    required this.openDate,
    required this.rarity,
  });

  Map<String, dynamic> toJson() {
    return {
      'dropDate': dropDate.toIso8601String(),
      'openDate': openDate.toIso8601String(),
      'rarity': rarity.name,
    };
  }

  factory Chest.fromJson(Map<String, dynamic> json) {
    return Chest(
      dropDate: DateTime.parse(json['dropDate']),
      openDate: DateTime.parse(json['dropDate']),
      rarity: ChestRarity.values.byName(json['rarity']),
    );
  }
}
