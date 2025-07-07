import 'dart:async';
import 'dart:math';
import 'package:cosmo_clicker/core/ui/boss_chest_open_notifier.dart';
import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChestPage extends StatefulWidget {
  const ChestPage({super.key});

  @override
  State<ChestPage> createState() => _ChestPageState();
}

class _ChestPageState extends State<ChestPage> {
  late final ChestController chestController;
  late final DustController dustController;
  late final ValueNotifier<DateTime> currentTimeNotifier;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    chestController = GetIt.instance<ChestController>();
    dustController = GetIt.instance<DustController>();
    currentTimeNotifier = ValueNotifier(DateTime.now());

    if (chestController.value.isEmpty) {
      final now = DateTime(2025, 7, 6);
      for (int i = 0; i < 10; i++) {
        final chest = Chest(
          dropDate: now.add(Duration(seconds: i)),
          rarity: ChestRarity.boss,
        );
        chestController.addChest(chest);
      }
    } //tirar o if

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentTimeNotifier.value = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    currentTimeNotifier.dispose();
    super.dispose();
  }

  Widget buildChestImage(chest) {
    switch (chest.rarity) {
      case ChestRarity.common:
      case ChestRarity.rare:
      case ChestRarity.stellar:
        return const Image(
          image: AssetImage('assets/images/dust_chest.png'),
          height: 100,
          alignment: Alignment.topLeft,
        );
      case ChestRarity.boss:
        return const Image(
          image: AssetImage('assets/images/boss_chest.png'),
          height: 100,
          fit: BoxFit.contain,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<int> generateChestReward() async {
    final random = Random();
    final int dust = 50 + random.nextInt(151);
    Future.delayed(const Duration(seconds: 1), () {
      dustController.addDust(dust);
    });
    return dust;
  }

  Widget buildChestOpener(
      Chest chest, Duration remainingTime, BuildContext context) {
    if (remainingTime <= Duration.zero) {
      return InkWell(
        child: const Text(
          'Aberto',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Abrindo o baú...'),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            },
          );

          final dust = await generateChestReward();
          chestController.openChest(chest);
          if (!context.mounted) return;
          Navigator.of(context).pop();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                title: const Text('🎉 Baú Aberto!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: Colors.amber, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      '+$dust Dust',
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok'),
                  )
                ],
              );
            },
          );
        },
      );
    } else {
      return Text(
        '${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 20),
      );
    }
  }

  Widget buildBossChestOpener(
      Chest chest, Duration remainingTime, BuildContext context) {
    if (remainingTime <= Duration.zero) {
      return InkWell(
        child: const Text(
          'Aberto',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () async {
          bossChestOpenNotifier.value = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Abrindo o baú...'),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            },
          );

          chestController.openChest(chest);
          if (!context.mounted) return;
          Navigator.of(context).pop();
        },
      );
    } else {
      return Text(
        '${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([chestController, currentTimeNotifier]),
      builder: (context, _) {
        final isEmpty = chestController.value.isEmpty;
        return Column(
          children: [
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.amber.shade200, size: 40),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhum baú encontrado. Comece a clicar para tentar dropar um baú!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ListView.separated(
                          itemCount: chestController.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            final chest = chestController.value[index];
                            final remainingTimeToChestOpen = chest.openDate
                                .difference(currentTimeNotifier.value);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    buildChestImage(chest),
                                    Text(
                                      chest.rarity.label,
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 16),
                                if (chest.rarity == ChestRarity.boss)
                                  buildBossChestOpener(
                                      chest, remainingTimeToChestOpen, context),
                                if (chest.rarity != ChestRarity.boss)
                                  buildChestOpener(
                                      chest, remainingTimeToChestOpen, context),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
