import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:cosmo_clicker/presentation/controllers/stats_controller.dart';
import 'package:cosmo_clicker/presentation/pages/chest_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      body: Center(
        child: ListenableBuilder(
          listenable: Listenable.merge([dustController, statsController]),
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Dust: ${dustController.value}',
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    dustController.addDust(statsController.value.dustPerClick);
                  },
                  child: const Image(
                    image: AssetImage('assets/images/estrela.png'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
