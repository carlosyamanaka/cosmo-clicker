import 'package:cosmo_clicker/domain/repositories/chest_counter_repository.dart';

class GetChestCounter {
  final ChestCounterRepository repository;

  GetChestCounter(this.repository);

  Future<int> call() => repository.getCounter();
}
