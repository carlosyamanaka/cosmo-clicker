import 'dart:async';
import 'package:cosmo_clicker/core/constants/app_assets.dart';
import 'package:cosmo_clicker/core/ui/boss_chest_open_notifier.dart';
import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'boss_battle_page.dart';

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
      for (int i = 0; i < 3; i++) {
        final chest = Chest(
          dropDate: now.add(Duration(seconds: i)),
          rarity: ChestRarity.boss,
        );
        chestController.addChest(chest);
        if (i == 0) {
          chestController.addChest(
            Chest(
              dropDate: now.add(const Duration(seconds: 5)),
              rarity: ChestRarity.common,
            ),
          );
        } else if (i == 1) {
          chestController.addChest(
            Chest(
              dropDate: now.add(const Duration(seconds: 10)),
              rarity: ChestRarity.rare,
            ),
          );
        } else if (i == 2) {
          chestController.addChest(
            Chest(
              dropDate: now.add(const Duration(seconds: 15)),
              rarity: ChestRarity.stellar,
            ),
          );
        }
      }
    } //TODO tirar o if

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
        return const Image(
          image: AssetImage(AppAssets.commonChest),
          height: 100,
          alignment: Alignment.topLeft,
        );
      case ChestRarity.rare:
        return const Image(
          image: AssetImage(AppAssets.rareChest),
          height: 100,
          alignment: Alignment.topLeft,
        );
      case ChestRarity.stellar:
        return const Image(
          image: AssetImage(AppAssets.stellarChest),
          height: 100,
          alignment: Alignment.topLeft,
        );
      case ChestRarity.boss:
        return const Image(
          image: AssetImage(AppAssets.bossChest),
          height: 100,
          alignment: Alignment.topLeft,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildChestOpener(
      Chest chest, Duration remainingTime, BuildContext context) {
    if (remainingTime <= Duration.zero) {
      return InkWell(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.amber.shade700,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.card_giftcard, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text('Abrir Baú',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 24),
                      CircularProgressIndicator(color: Colors.amber),
                      SizedBox(height: 16),
                      Text('Abrindo...',
                          style: TextStyle(fontSize: 22, color: Colors.white)),
                    ],
                  ),
                ),
              );
            },
          );

          final dust = await chestController.generateChestReward(chest);
          await chestController.openChest(chest);
          if (!context.mounted) return;
          Navigator.of(context).pop();

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome,
                          color: Colors.amber.shade400, size: 80),
                      const SizedBox(height: 18),
                      Text(
                        '+$dust Dust',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        chest.rarity.label,
                        style: TextStyle(
                            fontSize: 22, color: Colors.white.withOpacity(0.9)),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                title: const Text('Enfrentar o Boss?'),
                content: const Text(
                    'Tem certeza que deseja ir enfrentar o boss? Após isso não terá volta!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BossBattlePage(),
                        ),
                      );
                    },
                    child: const Text('Enfrentar'),
                  ),
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
