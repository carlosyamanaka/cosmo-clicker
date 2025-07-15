import 'package:cosmo_clicker/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage(AppAssets.home),
            height: 19,
            fit: BoxFit.cover,
          ),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage(AppAssets.shoppingCard),
            width: 22,
            fit: BoxFit.cover,
          ),
          label: 'Loja',
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage(AppAssets.treasureChest),
            height: 22,
            fit: BoxFit.cover,
          ),
          label: 'Tesouros',
        )
      ],
    );
  }
}
