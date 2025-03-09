import 'package:cosmo_clicker/domain/entities/dust.dart';

abstract class DustRepository {
  Future<Dust> getDust();
  Future<void> updateDust(int amount);
}
