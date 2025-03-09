class Stats {
  final int dustPerClick;
  final int dustPerSecond;

  Stats({
    required this.dustPerClick,
    required this.dustPerSecond,
  });

  Stats copyWith({int? dustPerClick, int? dustPerSecond}) {
    return Stats(
      dustPerClick: dustPerClick ?? this.dustPerClick,
      dustPerSecond: dustPerSecond ?? this.dustPerSecond,
    );
  }
}
