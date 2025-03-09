import 'package:shared_preferences/shared_preferences.dart';

abstract class DustLocalDataSource {
  Future<int> getDust();
  Future<void> saveDust(int amount);
}

class DustLocalDataSourceImpl implements DustLocalDataSource {
  static const _key = 'dust';

  @override
  Future<int> getDust() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  @override
  Future<void> saveDust(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, amount);
  }
}
