import 'dart:async';
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
  Timer? _timer;
  int _secondsLeft = 60;

  @override
  void initState() {
    super.initState();
    bossController = GetIt.instance<BossController>();
    statsController = GetIt.instance<StatsController>();
    trophyController = GetIt.instance<TrophyController>();
    bossController.reset();
    bossController.addListener(_checkBossDefeated);
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _secondsLeft--;
      });
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        _showFailedDialog();
      }
    });
  }

  @override
  void dispose() {
    bossController.removeListener(_checkBossDefeated);
    _timer?.cancel();
    super.dispose();
  }

  void _checkBossDefeated() async {
    if (bossController.value <= 0) {
      _timer?.cancel();
      await trophyController.addTrophy();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        HomePage.goToTab(0);
      }
    }
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Você falhou!',
          style: TextStyle(color: Colors.redAccent),
        ),
        content: const Text(
          'O boss não foi derrotado a tempo.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              HomePage.goToTab(0);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _backgroundColor() {
    final percent = 1 - (_secondsLeft / 60).clamp(0.0, 1.0);
    return Color.lerp(Colors.black, Colors.red.shade900, percent)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (details) {
                bossController.damage(statsController.value.dustPerClick);
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Tempo restante: ${_secondsLeft}s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
