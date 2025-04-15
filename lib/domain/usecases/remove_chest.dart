import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/domain/repositories/chest_repository.dart';

class RemoveChest {
  final ChestRepository repository;
  RemoveChest(this.repository);

  Future<void> call(Chest chest) => repository.removeChest(chest);
}
