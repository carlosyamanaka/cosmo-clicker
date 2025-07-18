import 'package:cosmo_clicker/core/ui/widgets/game_snackbar.dart';
import 'package:cosmo_clicker/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class CosmoClickerApp extends StatelessWidget {
  const CosmoClickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmo Clicker',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      navigatorKey: GameSnackbar.navigatorKey,
      home: const HomePage(),
    );
  }
}
