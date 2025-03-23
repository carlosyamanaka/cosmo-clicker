import 'package:cosmo_clicker/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class CosmoClickerApp extends StatelessWidget {
  const CosmoClickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Clicker',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
