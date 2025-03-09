// ignore_for_file: use_build_context_synchronously

import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:flutter/material.dart';
import 'package:cosmo_clicker/domain/entities/upgrade.dart';
import 'package:cosmo_clicker/presentation/controllers/upgrade_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:get_it/get_it.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late final UpgradeController upgradeController;
  late final StatsController statsController;
  late final DustController dustController;

  @override
  void initState() {
    super.initState();
    upgradeController = GetIt.instance<UpgradeController>();
    statsController = GetIt.instance<StatsController>();
    dustController = GetIt.instance<DustController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja de Upgrades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListenableBuilder(
          listenable: upgradeController,
          builder: (context, _) {
            return FutureBuilder<List<Upgrade>>(
              future: Future.value(upgradeController.getAvailableUpgrades()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum upgrade disponível.'));
                }

                final upgrades = snapshot.data!;

                return ListView.builder(
                  itemCount: upgrades.length,
                  itemBuilder: (context, index) {
                    final upgrade = upgrades[index];
                    return ListTile(
                      title: Text(upgrade.name),
                      subtitle: Text('Custo: ${upgrade.cost} Poeira Estelar'),
                      trailing: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () async {
                          final dust = await dustController.getDust();

                          if (dust.amount >= upgrade.cost) {
                            await upgradeController.buyUpgrade(upgrade);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Upgrade comprado com sucesso!')),
                            );
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Poeira Estelar insuficiente.')),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
