import 'package:cosmo_clicker/core/constants/app_assets.dart';
import 'package:cosmo_clicker/presentation/controllers/boss_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/trophy_controller.dart';
import 'package:cosmo_clicker/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BossBattlePage extends StatefulWidget {
  const BossBattlePage({super.key});

  @override
  State<BossBattlePage> createState() => _BossBattlePageState();
}

class _BossBattlePageState extends State<BossBattlePage> {
  late final BossController bossController;
  late final StatsController statsController;
  late final TrophyController trophyController;

  @override
  void initState() {
    super.initState();
    bossController = GetIt.instance<BossController>();
    statsController = GetIt.instance<StatsController>();
    trophyController = GetIt.instance<TrophyController>();
    bossController.reset();
    bossController.addListener(_checkBossDefeated);
  }

  @override
  void dispose() {
    bossController.removeListener(_checkBossDefeated);
    super.dispose();
  }

  void _checkBossDefeated() async {
    if (bossController.value <= 0) {
      await trophyController.addTrophy();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        HomePage.goToTab(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                bossController.damage(statsController.value.dustPerClick);
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    bossController.damage(statsController.value.dustPerClick);
                  },
                  child: Image.asset(
                    AppAssets.boss,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<int>(
                  valueListenable: bossController,
                  builder: (context, hp, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: hp / bossController.maxHp,
                        ),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 24,
                            backgroundColor: Colors.red.shade900,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.redAccent),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
