import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_snitch_mobile/src/drink_change_notifier.dart';
import 'package:sip_snitch_mobile/src/today_page.dart';

void main() {
  runApp(const SipSnitchApp());
}

class SipSnitchApp extends StatefulWidget {
  const SipSnitchApp({super.key});

  @override
  State<SipSnitchApp> createState() => _SipSnitchAppState();
}

class _SipSnitchAppState extends State<SipSnitchApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrinkChangeNotifier(),
      child: MaterialApp(
        home: TodayPage(),
      ),
    );
  }
}
