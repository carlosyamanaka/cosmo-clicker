import 'dart:async';
import 'dart:math';
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
  late final ValueNotifier<DateTime> dateTimeNow;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    chestController = GetIt.instance<ChestController>();
    dustController = GetIt.instance<DustController>();
    dateTimeNow = ValueNotifier(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      dateTimeNow.value = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    dateTimeNow.dispose();
    super.dispose();
  }

  Widget showChestImage(chest) {
    switch (chest.type) {
      case ChestType.dust:
        return const Image(
          image: AssetImage('assets/images/dust_chest.png'),
          height: 100,
          alignment: Alignment.topLeft,
        );
      case ChestType.boss:
        return const Image(
          image: AssetImage('assets/images/boss_chest.png'),
          fit: BoxFit.contain,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<int> chestRewardHandler() async {
    final random = Random();
    final int dust = 50 + random.nextInt(151);
    Future.delayed(const Duration(seconds: 1), () {
      dustController.addDust(dust);
    });
    return dust;
  }

  Widget openChestTimer(Chest chest, Duration duration, BuildContext context) {
    final remainingTime = const Duration(hours: 1) - duration;
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

          final dust = await chestRewardHandler();
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([chestController, dateTimeNow]),
      builder: (context, _) {
        return Column(
          children: [
            SizedBox(
              width: 100,
              child: InkWell(
                onTap: () {
                  chestController.addChest(Chest(
                      openDate: DateTime.now(),
                      rarity: ChestRarity.rare,
                      type: ChestType.dust));
                },
                child: const Image(
                  image: AssetImage('assets/images/estrela.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ListView.separated(
                    itemCount: chestController.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      final chest = chestController.value[index];
                      final duration =
                          dateTimeNow.value.difference(chest.openDate);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              showChestImage(chest),
                              Text(
                                chest.rarity.label,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          const SizedBox(width: 16),
                          openChestTimer(chest, duration, context),
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
