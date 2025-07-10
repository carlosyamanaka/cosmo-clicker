import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class TrophyController extends ValueNotifier<int> {
  TrophyController() : super(0) {
    _loadTrophy();
  }

  Future<void> _loadTrophy() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getInt('bossTrophyCount') ?? 0;
    notifyListeners();
  }

  Future<void> addTrophy() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = value + 1;
    await prefs.setInt('bossTrophyCount', newValue);
    value = newValue;
    notifyListeners();
  }
}
