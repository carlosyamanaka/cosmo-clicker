abstract class ChestProbabilityRepository {
  Future<void> saveProbability(double value);
  Future<double> getProbability();
}
