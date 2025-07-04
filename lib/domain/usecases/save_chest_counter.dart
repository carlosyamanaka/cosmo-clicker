import 'package:cosmo_clicker/domain/repositories/chest_counter_repository.dart';

class SaveChestCounter {
  final ChestCounterRepository repository;

  SaveChestCounter(this.repository);

  Future<void> call(int value) => repository.saveCounter(value);
}
