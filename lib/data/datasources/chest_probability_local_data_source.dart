import 'package:shared_preferences/shared_preferences.dart';

abstract class ChestProbabilityLocalDataSource {
  Future<void> saveProbability(double value);
  Future<double> getProbability();
}

class ChestProbabilityLocalDataSourceImpl
    implements ChestProbabilityLocalDataSource {
  static const _probabilityKey = 'chestDropProbability';

  @override
  Future<void> saveProbability(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_probabilityKey, value);
  }

  @override
  Future<double> getProbability() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_probabilityKey) ?? 0.01;
  }
}
