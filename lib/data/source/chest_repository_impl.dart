import 'package:cosmo_clicker/data/datasources/chest_local_data_source.dart';
import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/domain/repositories/chest_repository.dart';

class ChestRepositoryImpl implements ChestRepository {
  final ChestLocalDataSource localDataSource;

  ChestRepositoryImpl(this.localDataSource);

  @override
  Future<List<Chest>> getChests() async {
    final List<Chest> chests = await localDataSource.getChests();
    return chests;
  }
  
  @override
  Future<void> saveChest(Chest chest) async {
    await localDataSource.saveChest(chest);
  }

  @override
  Future<void> removeChest(Chest chest) async {
    await localDataSource.removeChest(chest);
  }
}
