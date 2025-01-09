import 'package:flutter/foundation.dart';
import 'package:sip_snitch_mobile/src/drink_repository.dart';
import 'package:sip_snitch_mobile/src/today_page.dart';

class DrinkChangeNotifier extends ChangeNotifier {
  final List<Drinks> _drinks = [
    const Drinks(name: 'Water', sips: 0),
    const Drinks(name: 'Coffee', sips: 0),
    const Drinks(name: 'RedBull', sips: 0),
    const Drinks(name: 'Club Mate', sips: 0),
    const Drinks(name: 'Beer', sips: 0),
  ];

  final DrinkRepository repository;

  DrinkChangeNotifier({required this.repository});

  List<Drinks> get drinks => _drinks.toList();

  Future<void> sip(String name) async {
    print('sipping $name');
    try {
      await repository.addSip(name);

      final drink = _drinks.firstWhere((drink) => drink.name == name);
      final index = _drinks.indexOf(drink);

      _drinks[index] = Drinks(name: drink.name, sips: drink.sips + 1);
      notifyListeners();
    } catch (e) {
      print('Error adding sip: $e');
    }
  }

  Future<void> fetchStats() async {
    print('fetching stats');
    // await Future.delayed(Duration(milliseconds: 1000));
    try {
      // Fetch stats from the repository
      final stats = await repository.fetchStats();

      // Update the local drinks list with the stats
      for (final drink in _drinks) {
        if (stats.containsKey(drink.name)) {
          final index = _drinks.indexOf(drink);
          _drinks[index] = Drinks(name: drink.name, sips: stats[drink.name]!);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching stats: $e');
      rethrow;
    }
  }
}
