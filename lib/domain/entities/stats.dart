class Stats {
  final int dustPerClick;
  final bool autoClickActive;

  Stats({
    required this.dustPerClick,
    required this.autoClickActive,
  });

  Stats copyWith({int? dustPerClick, bool? autoClickActive}) {
    return Stats(
      dustPerClick: dustPerClick ?? this.dustPerClick,
      autoClickActive: autoClickActive ?? this.autoClickActive,
    );
  }
}
