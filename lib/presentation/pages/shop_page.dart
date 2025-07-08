import 'package:flutter/material.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/presentation/controllers/upgrade_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:cosmo_clicker/core/utils/format_number.dart';

import '../../core/ui/animations/sprite_animation_widget.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late final UpgradeController upgradeController;
  late final StatsController statsController;
  late final DustController dustController;
  late int dustAmount;

  @override
  void initState() {
    super.initState();
    upgradeController = GetIt.instance<UpgradeController>();
    statsController = GetIt.instance<StatsController>();
    dustController = GetIt.instance<DustController>();
    dustAmount = 0;
    _loadDust();
  }

  Future<void> _loadDust() async {
    final dust = await dustController.getDust();
    setState(() {
      dustAmount = dust.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/shop_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/dust_chest.png',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatNumber(dustAmount),
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: upgradeController,
                builder: (context, _) {
                  final upgrades = upgradeController.value;
                  if (upgrades.isEmpty) {
                    return const Center(
                        child: Text('Nenhum upgrade disponível.',
                            style: TextStyle(color: Colors.white)));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: UpgradeList(upgrades: upgrades, onBuy: _loadDust),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AutoClickToggle(statsController: statsController),
            ),
          ],
        ),
      ],
    );
  }
}

class UpgradeList extends StatelessWidget {
  final List<Upgrade> upgrades;
  final VoidCallback onBuy;
  const UpgradeList({super.key, required this.upgrades, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: upgrades.length,
      separatorBuilder: (context, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final upgrade = upgrades[index];
        return UpgradeTile(upgrade: upgrade, onBuy: onBuy);
      },
    );
  }
}

class UpgradeTile extends StatelessWidget {
  final Upgrade upgrade;
  final VoidCallback onBuy;
  const UpgradeTile({super.key, required this.upgrade, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final dustController = GetIt.instance<DustController>();
    final upgradeController = GetIt.instance<UpgradeController>();
    return Card(
      color: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const SpriteAnimationWidget(
                  image: AssetImage('assets/images/Small_Blackball_10x26.png'),
                  frameCount: 60,
                  framesPerRow: 10,
                  frameWidth: 10,
                  frameHeight: 27,
                  frameDuration: Duration(milliseconds: 80),
                  scale: 2.0,
                )),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    upgrade.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    upgrade.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/dust_chest.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatNumber(upgrade.cost),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                final dust = await dustController.getDust();
                if (dust.amount >= upgrade.cost) {
                  await upgradeController.buyUpgradeItem(upgrade);
                  onBuy();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Upgrade comprado com sucesso!')),
                  );
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Poeira Estelar insuficiente.')),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_cart,
                    color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoClickToggle extends StatelessWidget {
  final StatsController statsController;
  const AutoClickToggle({super.key, required this.statsController});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        statsController.toggleAutoClick();
      },
      child: ListenableBuilder(
        listenable: statsController,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: statsController.value.autoClickActive
                  ? Colors.green
                  : Colors.red,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              'Ligar/Desligar Auto Clicker',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          );
        },
      ),
    );
  }
}
