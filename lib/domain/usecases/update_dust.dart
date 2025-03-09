import '../repositories/dust_repository.dart';

class UpdateDust {
  final DustRepository repository;

  UpdateDust(this.repository);

  Future<void> call(int amount) async {
    await repository.updateDust(amount);
  }
}
