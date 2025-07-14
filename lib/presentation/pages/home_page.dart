import 'package:cosmo_clicker/core/ui/widgets/custom_app_bar.dart';
import 'package:cosmo_clicker/presentation/pages/bottom_nav_bar.dart';
import 'package:cosmo_clicker/presentation/pages/chest_page.dart';
import 'package:cosmo_clicker/presentation/pages/main_page.dart';
import 'package:cosmo_clicker/presentation/pages/shop_page.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

enum HomePageTransition { fade, boss }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final ValueNotifier<int> tabNotifier = ValueNotifier(0);
  static final ValueNotifier<HomePageTransition> transitionNotifier =
      ValueNotifier(HomePageTransition.fade);

  static void goToTab(int index,
      {HomePageTransition transition = HomePageTransition.fade}) {
    transitionNotifier.value = transition;
    tabNotifier.value = index;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<int> _showAppBarFor = [0, 1, 2];
  final List<Widget> _pages = const [
    MainPage(),
    ShopPage(),
    ChestPage(),
  ];

  @override
  void initState() {
    super.initState();
    HomePage.tabNotifier.value = 0;
    HomePage.transitionNotifier.value = HomePageTransition.fade;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: HomePage.tabNotifier,
      builder: (context, selectedIndex, _) {
        return ValueListenableBuilder<HomePageTransition>(
          valueListenable: HomePage.transitionNotifier,
          builder: (context, transition, __) {
            return Scaffold(
              appBar: _showAppBarFor.contains(selectedIndex)
                  ? CustomAppBar(title: 'Cosmo Clicker')
                  : null,
              body: AnimatedSwitcher(
                duration: transition == HomePageTransition.boss
                    ? const Duration(milliseconds: 1500)
                    : const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  switch (transition) {
                    case HomePageTransition.boss:
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, _) {
                          final appear =
                              Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.5, 1.0,
                                  curve: Curves.easeOut),
                            ),
                          );
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: AnimatedOpacity(
                                  opacity: 0.8 * (1 - appear.value),
                                  duration: Duration.zero,
                                  child: Container(color: Colors.black),
                                ),
                              ),
                              Center(
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..scale(1 + 0.2 * (1 - appear.value)),
                                  child: Opacity(
                                    opacity: appear.value,
                                    child: child,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: AnimatedOpacity(
                                    opacity: 1 - appear.value,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    curve: Curves.easeOut,
                                    child: Image.asset(
                                      AppAssets.glitchGif,
                                      fit: BoxFit.cover,
                                      opacity:
                                          const AlwaysStoppedAnimation(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    case HomePageTransition.fade:
                    default:
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                  }
                },
                child: _pages[selectedIndex],
              ),
              bottomNavigationBar: BottomNavBar(
                selectedIndex: selectedIndex,
                onItemTapped: (index) => HomePage.goToTab(index),
              ),
            );
          },
        );
      },
    );
  }
}
