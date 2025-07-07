import 'package:cosmo_clicker/core/utils/format_number.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cosmo_clicker/domain/entities/stats.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final DustController controller = GetIt.instance<DustController>();
  final StatsController statsController = GetIt.instance<StatsController>();
  final ChestController chestController = GetIt.instance<ChestController>();
  CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: Colors.deepPurple.shade800,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/estrela.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.stars, color: Colors.amber.shade200, size: 18),
                  const SizedBox(width: 4),
                  const Text('DUST:',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  ListenableBuilder(
                    listenable: Listenable.merge([controller]),
                    builder: (context, __) {
                      return Text(
                        formatNumber(controller.value),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  const Spacer(),
                  Icon(Icons.casino, color: Colors.amber.shade200, size: 18),
                  const SizedBox(width: 4),
                  const Text(
                    'Chance Baú:',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  ValueListenableBuilder<double>(
                    valueListenable: chestController.dropProbability,
                    builder: (context, prob, _) {
                      return Text(
                        '${(prob * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.touch_app, color: Colors.amber.shade200, size: 18),
                  const SizedBox(width: 4),
                  const Text('Dust/Clique:',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  ValueListenableBuilder<Stats>(
                    valueListenable: statsController,
                    builder: (context, stats, _) {
                      return Text(
                        '${stats.dustPerClick}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(126);
}
