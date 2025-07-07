enum ChestRarity {
  common('Comum', Duration(seconds: 30)),
  rare('Raro', Duration(minutes: 1)),
  stellar('Estelar', Duration(minutes: 5)),
  boss('Boss', Duration(minutes: 15));

  final String label;
  final Duration openDelay;

  const ChestRarity(this.label, this.openDelay);
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
