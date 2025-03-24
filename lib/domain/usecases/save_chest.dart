import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/domain/repositories/chest_repository.dart';

class SaveChest {
  final ChestRepository repository;
  SaveChest(this.repository);

  Future<void> call(Chest chest) => repository.saveChest(chest);
}
