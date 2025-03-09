import '../../domain/entities/dust.dart';
import '../../domain/repositories/dust_repository.dart';
import '../datasources/dust_local_data_source.dart';

class DustRepositoryImpl implements DustRepository {
  final DustLocalDataSource localDataSource;

  DustRepositoryImpl(this.localDataSource);

  @override
  Future<Dust> getDust() async {
    final amount = await localDataSource.getDust();
    return Dust(amount: amount);
  }

  @override
  Future<void> updateDust(int amount) async {
    await localDataSource.saveDust(amount);
  }
}
