import 'package:cosmo_clicker/core/constants/app_assets.dart';
import 'package:cosmo_clicker/core/utils/format_number.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/trophy_controller.dart';
import 'package:cosmo_clicker/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cosmo_clicker/domain/entities/stats.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final DustController controller = GetIt.instance<DustController>();
  final StatsController statsController = GetIt.instance<StatsController>();
  final ChestController chestController = GetIt.instance<ChestController>();
  final TrophyController trophyController = GetIt.instance<TrophyController>();
  CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final cosmoIconSize = isSmallScreen ? 60.0 : 80.0;
    final settingsIconSize = isSmallScreen ? 60.0 : 80.0;
    final infoIconSize = isSmallScreen ? 20.0 : 32.0;

    return Material(
      elevation: 6,
      color: Colors.deepPurple.shade800,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Image.asset(
                      AppAssets.cosmoIcon,
                      width: cosmoIconSize,
                      height: cosmoIconSize,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: ValueListenableBuilder<int>(
                      valueListenable: trophyController,
                      builder: (context, trophyCount, _) {
                        if (trophyCount == 0) return const SizedBox.shrink();
                        return Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.amber.shade400,
                              size: 32,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                'x$trophyCount',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black54,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1440).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.dust,
                                  width: infoIconSize,
                                  height: infoIconSize,
                                ),
                                const SizedBox(width: 8),
                                ListenableBuilder(
                                  listenable: Listenable.merge([controller]),
                                  builder: (context, __) {
                                    return Text(
                                      formatNumber(controller.value),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1440).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.dustTap,
                                      width: infoIconSize,
                                      height: infoIconSize,
                                    ),
                                    const SizedBox(width: 8),
                                    ValueListenableBuilder<Stats>(
                                      valueListenable: statsController,
                                      builder: (context, stats, _) {
                                        return Text(
                                          '${stats.dustPerClick}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.chestChance,
                                      width: infoIconSize,
                                      height: infoIconSize,
                                    ),
                                    const SizedBox(width: 8),
                                    ValueListenableBuilder<double>(
                                      valueListenable:
                                          chestController.dropProbability,
                                      builder: (context, prob, _) {
                                        return Text(
                                          '${(prob * 100).toStringAsFixed(2)}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset(
                    AppAssets.settings,
                    width: settingsIconSize,
                    height: settingsIconSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(136);
}
