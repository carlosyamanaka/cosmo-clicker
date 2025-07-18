import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
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
  final player = AudioPlayer();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    chestController = GetIt.instance<ChestController>();
    dustController = GetIt.instance<DustController>();
    currentTimeNotifier = ValueNotifier(DateTime.now());

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
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final buttonFontSize = isSmallScreen ? 14.0 : 22.0;
    final buttonPadding = isSmallScreen
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    final iconSize = isSmallScreen ? 18.0 : 28.0;

    if (remainingTime <= Duration.zero) {
      return InkWell(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: buttonPadding,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.card_giftcard, color: Colors.white, size: iconSize),
              SizedBox(width: isSmallScreen ? 6 : 12),
              Text(
                'Abrir Baú',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          await player.play(
            AssetSource('sounds/winfantasia.mp3'),
          );
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
                        '+$dust Fragmentos Estelares',
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
        style: TextStyle(fontSize: buttonFontSize),
      );
    }
  }

  Widget buildBossChestOpener(
      Chest chest, Duration remainingTime, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final buttonFontSize = isSmallScreen ? 14.0 : 22.0;
    final buttonPadding = isSmallScreen
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 28, vertical: 14);
    final iconSize = isSmallScreen ? 20.0 : 30.0;

    if (remainingTime <= Duration.zero) {
      return InkWell(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: buttonPadding,
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade700,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.5),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield, color: Colors.amber, size: iconSize),
              SizedBox(width: isSmallScreen ? 7 : 14),
              Text(
                'Enfrentar Boss',
                style: TextStyle(
                  fontSize: buttonFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
        style: TextStyle(fontSize: buttonFontSize),
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
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Tooltip(
                  message:
                      'Dropar um baú de boss é apenas para testar a funcionalidade.\nPara ter a experiência completa, não use esse botão!',
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                    ),
                    icon: const Icon(Icons.bug_report, color: Colors.amber),
                    label: const Text(
                      'Adicionar baú de boss',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      final now = DateTime.now();
                      chestController.addChest(
                        Chest(
                          dropDate: now.add(const Duration(seconds: 5)),
                          rarity: ChestRarity.boss,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Dropar um baú de boss é apenas para testar a funcionalidade.Para ter a experiência completa, não use esse botão!',
                          ),
                          backgroundColor: Colors.deepPurple,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                color:
                                    Colors.deepPurple.shade900.withOpacity(0.7),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 110,
                                        child: Column(
                                          children: [
                                            buildChestImage(chest),
                                            const SizedBox(height: 8),
                                            Text(
                                              chest.rarity.label,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child:
                                              chest.rarity == ChestRarity.boss
                                                  ? buildBossChestOpener(
                                                      chest,
                                                      remainingTimeToChestOpen,
                                                      context)
                                                  : buildChestOpener(
                                                      chest,
                                                      remainingTimeToChestOpen,
                                                      context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 16);
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
