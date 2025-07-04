import 'package:shared_preferences/shared_preferences.dart';

abstract class ChestCounterLocalDataSource {
  Future<void> saveCounter(int value);
  Future<int> getCounter();
}

class ChestCounterLocalDataSourceImpl implements ChestCounterLocalDataSource {
  static const _counterKey = 'chestsSinceLastBoss';

  @override
  Future<void> saveCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);
  }

  @override
  Future<int> getCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_counterKey) ?? 0;
  }
}
