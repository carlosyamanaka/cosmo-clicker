import 'package:cosmo_clicker/domain/repositories/chest_probability_repository.dart';

class SaveChestProbability {
  final ChestProbabilityRepository repository;

  SaveChestProbability(this.repository);

  Future<void> call(double value) => repository.saveProbability(value);
}
