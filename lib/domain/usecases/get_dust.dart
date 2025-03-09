import '../entities/dust.dart';
import '../repositories/dust_repository.dart';

class GetDust {
  final DustRepository repository;

  GetDust(this.repository);

  Future<Dust> call() async {
    return await repository.getDust();
  }
}
