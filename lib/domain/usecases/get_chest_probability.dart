import 'package:cosmo_clicker/domain/repositories/chest_probability_repository.dart';

class GetChestProbability {
  final ChestProbabilityRepository repository;

  GetChestProbability(this.repository);

  Future<double> call() => repository.getProbability();
}
