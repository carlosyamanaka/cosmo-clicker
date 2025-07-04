import 'package:cosmo_clicker/core/ui/animations/particle_explosion.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ValueNotifier<Offset?> _tapPositionNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _chestDroppedNotifier = ValueNotifier(false);

  late final DustController dustController;
  late final StatsController statsController;
  late final ChestController chestController;

  late final bool _autoClickActive;

  int _shouldAutoClick = 0;

  @override
  void initState() {
    super.initState();
    dustController = GetIt.instance<DustController>();
    statsController = GetIt.instance<StatsController>();
    chestController = GetIt.instance<ChestController>();
    _autoClickActive = statsController.value.autoClickActive;
  }

  void _updateTapPosition(Offset position) {
    _tapPositionNotifier.value = position;
  }

  void _clickHandler(details) async {
    dustController.addDust(statsController.value.dustPerClick);
    final before = chestController.value.length;
    await chestController.tryDropChest();
    final after = chestController.value.length;
    if (after > before) {
      _chestDroppedNotifier.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        _chestDroppedNotifier.value = false;
      });
    }
    _updateTapPosition(details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        return SizedBox(
          height: availableHeight,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ListenableBuilder(
                      listenable:
                          Listenable.merge([dustController, statsController]),
                      builder: (context, _) {
                        return GestureDetector(
                          onPanUpdate: (details) {
                            if (_autoClickActive) {
                              _shouldAutoClick++;
                              if (_shouldAutoClick >= 20) {
                                _clickHandler(details);
                                _shouldAutoClick = 0;
                              }
                            }
                          },
                          onTapDown: (details) {
                            _clickHandler(details);
                          },
                          child: Stack(
                            children: [
                              const Positioned.fill(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/cosmo_main.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ValueListenableBuilder<Offset?>(
                                valueListenable: _tapPositionNotifier,
                                builder: (context, tapPosition, _) {
                                  return ParticleExplosion(
                                      tapPosition: tapPosition);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _chestDroppedNotifier,
                      builder: (context, dropped, _) {
                        if (!dropped) return const SizedBox.shrink();
                        return AnimatedOpacity(
                          opacity: dropped ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/boss_chest.png',
                                  width: 80),
                              const SizedBox(height: 8),
                              Text(
                                'Baú Dropado!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade700,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black45,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      },
    );
  }
}
