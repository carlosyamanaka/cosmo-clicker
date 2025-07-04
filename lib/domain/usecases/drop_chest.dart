import 'dart:math';

class DropChest {
  final Random _random;

  DropChest({Random? random}) : _random = random ?? Random();

  bool call(double probability) {
    return _random.nextDouble() < probability;
  }
}
