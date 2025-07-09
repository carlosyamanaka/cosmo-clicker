import 'package:flutter/material.dart';

class BossController extends ValueNotifier<int> {
  final int maxHp;
  BossController({this.maxHp = 100}) : super(100);

  void damage(int amount) {
    value = (value - amount).clamp(0, maxHp);
    notifyListeners();
  }

  void reset() {
    value = maxHp;
    notifyListeners();
  }
}
