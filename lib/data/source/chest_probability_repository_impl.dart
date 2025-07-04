import 'package:cosmo_clicker/data/datasources/chest_probability_local_data_source.dart';
import 'package:cosmo_clicker/domain/repositories/chest_probability_repository.dart';

class ChestProbabilityRepositoryImpl implements ChestProbabilityRepository {
  final ChestProbabilityLocalDataSource dataSource;

  ChestProbabilityRepositoryImpl(this.dataSource);

  @override
  Future<void> saveProbability(double value) =>
      dataSource.saveProbability(value);

  @override
  Future<double> getProbability() => dataSource.getProbability();
}
