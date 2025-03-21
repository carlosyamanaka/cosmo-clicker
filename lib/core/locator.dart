import 'package:cosmo_clicker/data/datasources/stats_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/upgrade_local_data_source.dart';
import 'package:cosmo_clicker/data/source/dust_repository_impl.dart';
import 'package:cosmo_clicker/data/source/stats_repository_impl.dart';
import 'package:cosmo_clicker/data/source/upgrade_repository_impl.dart';
import 'package:cosmo_clicker/domain/repositories/stats_repository.dart';
import 'package:cosmo_clicker/domain/repositories/upgrade_repository.dart';
import 'package:cosmo_clicker/domain/usecases/buy_upgrade.dart';
import 'package:cosmo_clicker/domain/usecases/get_available_upgrades.dart';
import 'package:cosmo_clicker/domain/usecases/get_stats.dart';
import 'package:cosmo_clicker/domain/usecases/update_stats.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/upgrade_controller.dart';
import 'package:get_it/get_it.dart';
import '../data/datasources/dust_local_data_source.dart';
import '../domain/repositories/dust_repository.dart';
import '../domain/usecases/get_dust.dart';
import '../domain/usecases/update_dust.dart';
import '../presentation/controllers/dust_controller.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Data Source
  locator.registerLazySingleton<DustLocalDataSource>(
      () => DustLocalDataSourceImpl());

  locator.registerLazySingleton<StatsLocalDataSource>(
    () => StatsLocalDataSourceImpl(),
  );
  locator.registerLazySingleton<UpgradeLocalDataSource>(
    () => UpgradeLocalDataSourceImpl(),
  );

  // Repository
  locator.registerLazySingleton<DustRepository>(
      () => DustRepositoryImpl(locator<DustLocalDataSource>()));
  locator.registerLazySingleton<UpgradeRepository>(() => UpgradeRepositoryImpl(
      locator<UpgradeLocalDataSource>(),
      locator<StatsLocalDataSource>(),
      locator<DustLocalDataSource>()));
  locator.registerLazySingleton<StatsRepository>(
      () => StatsRepositoryImpl(locator<StatsLocalDataSource>()));

  // Use Cases
  locator
      .registerLazySingleton<GetDust>(() => GetDust(locator<DustRepository>()));
  locator.registerLazySingleton<UpdateDust>(
      () => UpdateDust(locator<DustRepository>()));

  locator.registerLazySingleton<GetStats>(
      () => GetStats(locator<StatsRepository>()));
  locator.registerLazySingleton<UpdateStats>(
      () => UpdateStats(locator<StatsRepository>()));

  locator.registerLazySingleton<GetAvailableUpgrades>(
      () => GetAvailableUpgrades(locator<UpgradeRepository>()));
  locator.registerLazySingleton<BuyUpgrade>(
      () => BuyUpgrade(locator<UpgradeRepository>()));

  // Controller
  locator.registerLazySingleton<DustController>(
      () => DustController(locator<GetDust>(), locator<UpdateDust>()));

  locator.registerLazySingleton<StatsController>(
      () => StatsController(locator<GetStats>(), locator<UpdateStats>()));

  locator.registerLazySingleton<UpgradeController>(() => UpgradeController(
        locator<GetAvailableUpgrades>(),
        locator<BuyUpgrade>(),
        locator<DustController>(),
        locator<StatsController>(),
      ));
}
