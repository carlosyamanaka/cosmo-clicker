import 'package:flutter/material.dart';
import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
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
    return ListenableBuilder(
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
                return const Center(child: Text('Nenhum upgrade disponível.'));
              }

              final upgrades = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    UpgradeList(upgrades: upgrades),
                    const SizedBox(height: 16),
                    AutoClickToggle(statsController: statsController),
                  ],
                ),
              );
            },
          );
        });
  }
}

class UpgradeList extends StatelessWidget {
  final List<Upgrade> upgrades;
  const UpgradeList({super.key, required this.upgrades});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: upgrades.length,
      itemBuilder: (context, index) {
        final upgrade = upgrades[index];
        return UpgradeTile(upgrade: upgrade);
      },
    );
  }
}

class UpgradeTile extends StatelessWidget {
  final Upgrade upgrade;
  const UpgradeTile({super.key, required this.upgrade});

  @override
  Widget build(BuildContext context) {
    final dustController = GetIt.instance<DustController>();
    final upgradeController = GetIt.instance<UpgradeController>();

    return ListTile(
      title: Text(upgrade.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(upgrade.description),
          const SizedBox(height: 4),
          Text('Custo: ${upgrade.cost} Poeira Estelar'),
          const Divider(),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.shopping_cart),
        onPressed: () async {
          final dust = await dustController.getDust();
          if (dust.amount >= upgrade.cost) {
            await upgradeController.buyUpgradeItem(upgrade);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upgrade comprado com sucesso!')),
            );
          } else {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Poeira Estelar insuficiente.')),
            );
          }
        },
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
            return Text(
              'Ligar/Desligar Auto Clicker',
              style: TextStyle(
                color: statsController.value.autoClickActive
                    ? Colors.green
                    : Colors.red,
              ),
            );
          }),
    );
  }
}
