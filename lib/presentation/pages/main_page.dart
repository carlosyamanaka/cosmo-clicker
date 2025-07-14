import 'package:audioplayers/audioplayers.dart';
import 'package:cosmo_clicker/core/ui/animations/particle_explosion.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/upgrade_controller.dart';
import 'package:cosmo_clicker/presentation/widgets/star_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/core/ui/boss_chest_open_notifier.dart';
import 'package:cosmo_clicker/presentation/widgets/floating_text.dart';
import 'package:cosmo_clicker/core/ui/widgets/game_snackbar.dart';

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
  late final UpgradeController upgradeController;

  late final bool _autoClickActive;
  int _shouldAutoClick = 0;

  late final AudioPlayer player;

  final List<FloatingText> _floatingTexts = [];

  @override
  void initState() {
    super.initState();
    dustController = GetIt.instance<DustController>();
    statsController = GetIt.instance<StatsController>();
    chestController = GetIt.instance<ChestController>();
    upgradeController = GetIt.instance<UpgradeController>();
    _autoClickActive = statsController.value.autoClickActive;
    player = AudioPlayer();
  }

  void _updateTapPosition(Offset position) {
    _tapPositionNotifier.value = position;
  }

  void _showFloatingText(Offset position, int value) {
    final key = UniqueKey();
    setState(() {
      _floatingTexts.add(FloatingText(
        key: key,
        position: position,
        value: value,
        onCompleted: () {
          setState(() {
            _floatingTexts.removeWhere((t) => t.key == key);
          });
        },
      ));
    });
  }

  void _clickHandler(details) async {
    await player.play(AssetSource('sounds/level-up-bonus-sequence-1.mp3'));
    dustController.addDust(statsController.value.dustPerClick);
    final before = chestController.value.length;
    await chestController.tryDropChest();
    final after = chestController.value.length;
    if (after > before) {
      final droppedChest = chestController.value.last;
      _chestDroppedNotifier.value = true;
      GameSnackbar.show('Baú dropado: ${droppedChest.rarity.label}',
          customLeading: droppedChest.rarity.image);
      Future.delayed(const Duration(seconds: 1), () {
        _chestDroppedNotifier.value = false;
      });
    }
    _updateTapPosition(details.localPosition);
    _showFloatingText(
      details.localPosition,
      statsController.value.dustPerClick,
    );
    Future.delayed(const Duration(milliseconds: 120), () {
      _tapPositionNotifier.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: bossChestOpenNotifier,
      builder: (context, bossOpen, _) {
        return Stack(
          children: [
            LayoutBuilder(
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
                              listenable: Listenable.merge(
                                  [dustController, statsController]),
                              builder: (context, _) {
                                return Listener(
                                  behavior: HitTestBehavior.opaque,
                                  onPointerMove: (details) {
                                    if (_autoClickActive) {
                                      _shouldAutoClick++;
                                      if (_shouldAutoClick >= 10) {
                                        _clickHandler(details);
                                        _shouldAutoClick = 0;
                                      }
                                    }
                                  },
                                  onPointerDown: (details) {
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
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          return ValueListenableBuilder<
                                              List<Upgrade>>(
                                            valueListenable: upgradeController,
                                            builder: (context, upgrades, _) {
                                              final starUpgrade =
                                                  upgrades.firstWhere(
                                                (u) =>
                                                    u.name ==
                                                    'Núcleos de estrelas',
                                                orElse: () => Upgrade(
                                                  name: 'Núcleos de estrelas',
                                                  level: 0,
                                                  baseCost: 0,
                                                  imagePath: '',
                                                ),
                                              );
                                              return StarOverlay(
                                                starCount: starUpgrade.level,
                                                width: constraints.maxWidth,
                                                height: constraints.maxHeight,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      ValueListenableBuilder<Offset?>(
                                        valueListenable: _tapPositionNotifier,
                                        builder: (context, tapPosition, _) {
                                          return ParticleExplosion(
                                              tapPosition: tapPosition);
                                        },
                                      ),
                                      ..._floatingTexts,
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
            ),
          ],
        );
      },
    );
  }
}
