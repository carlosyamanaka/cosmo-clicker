import 'package:flutter/material.dart';
import '../../domain/usecases/get_dust.dart';
import '../../domain/usecases/update_dust.dart';

class DustController extends ValueNotifier<int> {
  final GetDust getDust;
  final UpdateDust updateDust;

  DustController(this.getDust, this.updateDust) : super(0) {
    _loadDust();
  }

  Future<void> _loadDust() async {
    final dust = await getDust();
    value = dust.amount;
  }

  void addDust(int amount) {
    value += amount;
    updateDust(value);
    notifyListeners();
  }

  void removeDust(int amount) {
    value -= amount;
    updateDust(value);
    notifyListeners();
  }
}
