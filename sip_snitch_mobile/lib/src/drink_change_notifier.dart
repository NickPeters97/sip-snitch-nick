import 'package:flutter/foundation.dart';
import 'package:sip_snitch_mobile/src/today_page.dart';

class DrinkChangeNotifier extends ChangeNotifier {
  List<Drinks> get drinks => _drinks.toList();

  final List<Drinks> _drinks = [
    const Drinks(name: 'Water', sips: 0),
    const Drinks(name: 'Coffee', sips: 0),
    const Drinks(name: 'RedBull', sips: 0),
    const Drinks(name: 'Club Mate', sips: 0),
    const Drinks(name: 'Beer', sips: 0),
  ];

  void sip(String name) {
    final drink = _drinks.firstWhere((drink) => drink.name == name);
    final index = _drinks.indexOf(drink);
    _drinks[index] = Drinks(name: drink.name, sips: drink.sips + 1);
    notifyListeners();
  }
}
