import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class TrophyController extends ValueNotifier<bool> {
  TrophyController() : super(false) {
    _loadTrophy();
  }

  Future<void> _loadTrophy() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getBool('bossTrophy') ?? false;
    notifyListeners();
  }

  Future<void> setTrophy(bool hasTrophy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bossTrophy', hasTrophy);
    value = hasTrophy;
    notifyListeners();
  }
}
