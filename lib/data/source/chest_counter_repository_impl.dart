import 'package:cosmo_clicker/data/datasources/chest_counter_local_data_source.dart';
import 'package:cosmo_clicker/domain/repositories/chest_counter_repository.dart';

class ChestCounterRepositoryImpl implements ChestCounterRepository {
  final ChestCounterLocalDataSource dataSource;

  ChestCounterRepositoryImpl(this.dataSource);

  @override
  Future<void> saveCounter(int value) => dataSource.saveCounter(value);

  @override
  Future<int> getCounter() => dataSource.getCounter();
}
