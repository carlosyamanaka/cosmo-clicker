import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/domain/repositories/chest_repository.dart';

class GetChests {
  final ChestRepository repository;
  GetChests(this.repository);

  Future<List<Chest>> call() => repository.getChests();
}