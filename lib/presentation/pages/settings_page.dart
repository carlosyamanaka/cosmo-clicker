import 'package:flutter/material.dart';
import 'package:cosmo_clicker/core/constants/app_assets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.settings,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 24),
              Image.asset(
                AppAssets.cosmoIcon,
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 32),
              const Text(
                'Obrigado por testar o Cosmo Clicker!\n\nSeu feedback é muito importante para o desenvolvimento do jogo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
          
            ],
          ),
        ),
      ),
    );
  }
}
