import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final DustController dustController;
  late final StatsController statsController;

  @override
  void initState() {
    super.initState();
    dustController = GetIt.instance<DustController>();
    statsController = GetIt.instance<StatsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmo Clicker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: Listenable.merge([dustController, statsController]),
          builder: (context, _) {
            return FutureBuilder(
                future: statsController
                    .getStats()
                    .then((value) => value.dustPerClick),
                builder: (context, snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Dust: ${dustController.value}',
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          dustController.addDust(snapshot.data as int);
                        },
                        child: const Image(
                          image: AssetImage('assets/images/estrela.png'),
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
