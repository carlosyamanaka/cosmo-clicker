import 'package:flutter/material.dart';

class BossChestOpenNotifier extends ValueNotifier<bool> {
  BossChestOpenNotifier() : super(false);
}

final bossChestOpenNotifier = BossChestOpenNotifier();
