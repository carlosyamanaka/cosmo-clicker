import 'dart:async';
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
  final bool _autoClickerOn = true;

  late final DustController dustController;
  late final StatsController statsController;

  @override
  void initState() {
    super.initState();
    dustController = GetIt.instance<DustController>();
    statsController = GetIt.instance<StatsController>();
  }

  void _updateTapPosition(Offset position) {
    if (_autoClickerOn) {
      _tapPositionNotifier.value = position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListenableBuilder(
        listenable: Listenable.merge([dustController, statsController]),
        builder: (context, _) {
          return GestureDetector(
            onPanUpdate: (details) {
              dustController.addDust(statsController.value.dustPerClick);
              _updateTapPosition(details.localPosition);
            },
            onTapDown: (details) {
              _updateTapPosition(details.localPosition);
              dustController.addDust(statsController.value.dustPerClick);
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
