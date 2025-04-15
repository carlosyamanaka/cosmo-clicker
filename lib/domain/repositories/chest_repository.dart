import 'package:cosmo_clicker/domain/entities/chest.dart';

abstract class ChestRepository {
  Future<void> saveChest(Chest chest);
  Future<void> removeChest(Chest chest);
  Future<List<Chest>> getChests();
}
