import 'dart:async';
import 'package:cosmo_clicker/domain/entities/chest.dart';
import 'package:cosmo_clicker/presentation/controllers/chest_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChestPage extends StatefulWidget {
  const ChestPage({super.key});

  @override
  State<ChestPage> createState() => _ChestPageState();
}

class _ChestPageState extends State<ChestPage> {
  late final ChestController chestController;
  late final ValueNotifier<DateTime> dateTimeNow;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    chestController = GetIt.instance<ChestController>();
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([chestController, dateTimeNow]),
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: ListView.builder(
                    itemCount: chestController.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      final chest = chestController.value[index];
                      final duration = dateTimeNow.value.difference(chest.openDate);
                      
                      return Text(
                        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
