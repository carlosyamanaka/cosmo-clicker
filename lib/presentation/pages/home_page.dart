import 'package:cosmo_clicker/core/ui/widgets/custom_app_bar.dart';
import 'package:cosmo_clicker/presentation/pages/bottom_nav_bar.dart';
import 'package:cosmo_clicker/presentation/pages/chest_page.dart';
import 'package:cosmo_clicker/presentation/pages/main_page.dart';
import 'package:cosmo_clicker/presentation/pages/shop_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<int> _showAppBarFor = [0, 1, 2];
  final List<Widget> _pages = const [
    MainPage(),
    ShopPage(),
    ChestPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBarFor.contains(_selectedIndex)
          ? CustomAppBar(title: 'Cosmo Clicker')
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
