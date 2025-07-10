import 'package:flutter/material.dart';

class BossController extends ValueNotifier<int> {
  final int baseHp;
  final ValueNotifier<int> trophyCount;

  BossController({
    this.baseHp = 100,
    required this.trophyCount,
  }) : super(100) {
    trophyCount.addListener(_updateHp);
    _updateHp();
  }

  void _updateHp() {
    final hp = baseHp * (1 << trophyCount.value);
    value = hp;
  }

  void damage(int amount) {
    value = (value - amount).clamp(0, maxHp);
    notifyListeners();
  }

  int get maxHp => baseHp * (1 << trophyCount.value);

  void reset() {
    value = maxHp;
    notifyListeners();
  }

  @override
  void dispose() {
    trophyCount.removeListener(_updateHp);
    super.dispose();
  }
}
