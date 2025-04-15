import 'package:cosmo_clicker/core/ui/animations/particle_explosion.dart';
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

  late final DustController dustController;
  late final StatsController statsController;

  late final bool _autoClickActive;

  int _shouldAutoClick = 0;

  @override
  void initState() {
    super.initState();
    dustController = GetIt.instance<DustController>();
    statsController = GetIt.instance<StatsController>();
    _autoClickActive = statsController.value.autoClickActive;
  }

  void _updateTapPosition(Offset position) {
    _tapPositionNotifier.value = position;
  }

  void _clickHandler(details) {
    dustController.addDust(statsController.value.dustPerClick);
    _updateTapPosition(details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListenableBuilder(
        listenable: Listenable.merge([dustController, statsController]),
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
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/cosmo_main.png'),
                  ),
                ),
                ValueListenableBuilder<Offset?>(
                  valueListenable: _tapPositionNotifier,
                  builder: (context, tapPosition, _) {
                    return ParticleExplosion(tapPosition: tapPosition);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
