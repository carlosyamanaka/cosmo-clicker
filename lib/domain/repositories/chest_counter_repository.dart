abstract class ChestCounterRepository {
  Future<void> saveCounter(int value);
  Future<int> getCounter();
}
