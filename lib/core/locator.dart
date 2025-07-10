import 'package:cosmo_clicker/data/datasources/chest_counter_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/chest_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/stats_local_data_source.dart';
import 'package:cosmo_clicker/data/datasources/upgrade_local_data_source.dart';
import 'package:cosmo_clicker/data/source/chest_counter_repository_impl.dart';
import 'package:cosmo_clicker/data/source/chest_repository_impl.dart';
import 'package:cosmo_clicker/data/source/dust_repository_impl.dart';
import 'package:cosmo_clicker/data/source/stats_repository_impl.dart';
import 'package:cosmo_clicker/data/source/upgrade_repository_impl.dart';
import 'package:cosmo_clicker/domain/repositories/chest_counter_repository.dart';
import 'package:cosmo_clicker/domain/repositories/chest_repository.dart';
import 'package:cosmo_clicker/domain/repositories/stats_repository.dart';
import 'package:cosmo_clicker/domain/repositories/upgrade_repository.dart';
import 'package:cosmo_clicker/domain/usecases/buy_upgrade.dart';
import 'package:cosmo_clicker/domain/usecases/drop_chest.dart';
import 'package:cosmo_clicker/domain/usecases/get_available_upgrades.dart';
import 'package:cosmo_clicker/domain/usecases/get_chests.dart';
import 'package:cosmo_clicker/domain/usecases/get_chest_counter.dart';
import 'package:cosmo_clicker/domain/usecases/get_stats.dart';
import 'package:cosmo_clicker/domain/usecases/remove_chest.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest_counter.dart';
import 'package:cosmo_clicker/domain/usecases/update_stats.dart';
import 'package:cosmo_clicker/presentation/controllers/boss_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/upgrade_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/trophy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/datasources/dust_local_data_source.dart';
import '../domain/repositories/dust_repository.dart';
import '../domain/usecases/get_dust.dart';
import '../domain/usecases/update_dust.dart';
import '../presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/data/datasources/chest_probability_local_data_source.dart';
import 'package:cosmo_clicker/data/source/chest_probability_repository_impl.dart';
import 'package:cosmo_clicker/domain/repositories/chest_probability_repository.dart';
import 'package:cosmo_clicker/domain/usecases/get_chest_probability.dart';
import 'package:cosmo_clicker/domain/usecases/save_chest_probability.dart';

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
  locator.registerLazySingleton<ChestLocalDataSource>(
    () => ChestLocalDataSourceImpl(),
  );
  locator.registerLazySingleton<ChestCounterLocalDataSource>(
    () => ChestCounterLocalDataSourceImpl(),
  );
  locator.registerLazySingleton<ChestProbabilityLocalDataSource>(
    () => ChestProbabilityLocalDataSourceImpl(),
  );

  // Repository
  locator.registerLazySingleton<DustRepository>(
      () => DustRepositoryImpl(locator<DustLocalDataSource>()));
  locator.registerLazySingleton<UpgradeRepository>(() => UpgradeRepositoryImpl(
        locator<UpgradeLocalDataSource>(),
        locator<StatsLocalDataSource>(),
        locator<DustLocalDataSource>(),
        locator<SaveChestProbability>(),
        locator<GetChestProbability>(),
      ));
  locator.registerLazySingleton<StatsRepository>(
      () => StatsRepositoryImpl(locator<StatsLocalDataSource>()));
  locator.registerLazySingleton<ChestRepository>(
      () => ChestRepositoryImpl(locator<ChestLocalDataSource>()));
  locator.registerLazySingleton<ChestCounterRepository>(
    () => ChestCounterRepositoryImpl(locator<ChestCounterLocalDataSource>()),
  );
  locator.registerLazySingleton<ChestProbabilityRepository>(
    () => ChestProbabilityRepositoryImpl(
        locator<ChestProbabilityLocalDataSource>()),
  );

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

  locator.registerLazySingleton<GetChests>(
      () => GetChests(locator<ChestRepository>()));
  locator.registerLazySingleton<SaveChest>(
      () => SaveChest(locator<ChestRepository>()));
  locator.registerLazySingleton<RemoveChest>(
      () => RemoveChest(locator<ChestRepository>()));

  locator.registerLazySingleton<GetChestCounter>(
    () => GetChestCounter(locator<ChestCounterRepository>()),
  );
  locator.registerLazySingleton<SaveChestCounter>(
    () => SaveChestCounter(locator<ChestCounterRepository>()),
  );
  locator.registerLazySingleton<GetChestProbability>(
    () => GetChestProbability(locator<ChestProbabilityRepository>()),
  );
  locator.registerLazySingleton<SaveChestProbability>(
    () => SaveChestProbability(locator<ChestProbabilityRepository>()),
  );

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
        locator<ChestController>(),
        locator<SaveChestProbability>(),
      ));

  locator.registerLazySingleton<DropChest>(() => DropChest());
  locator.registerLazySingleton<ValueNotifier<double>>(
      () => ValueNotifier<double>(0.01));

  locator.registerLazySingleton<ChestController>(() => ChestController(
        locator<GetChests>(),
        locator<SaveChest>(),
        locator<RemoveChest>(),
        locator<DropChest>(),
        locator<ValueNotifier<double>>(),
        locator<GetChestCounter>(),
        locator<SaveChestCounter>(),
        locator<GetChestProbability>(),
        locator<SaveChestProbability>(),
        locator<DustController>(),
      ));

  locator.registerLazySingleton<BossController>(
      () => BossController(trophyCount: locator<TrophyController>()));
  locator.registerLazySingleton<TrophyController>(() => TrophyController());
}
