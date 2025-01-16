import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_snitch_mobile/src/drink_change_notifier.dart';
import 'package:sip_snitch_mobile/src/user_auth.dart';
import 'package:unsplash_client/unsplash_client.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<UserAuthenticationNotifier>().signInAnonymously();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final notifier = context.read<DrinkChangeNotifier>();
      await notifier.fetchStats();
    } catch (error) {
      print('Error fetching stats: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<DrinkChangeNotifier>();
    final userNotifier = context.watch<UserAuthenticationNotifier>();
    if (!userNotifier.isUserSignedIn) {
      return Scaffold(
        body: Center(
            child: GestureDetector(
          onTap: userNotifier.signInAnonymously,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.teal,
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'The use is not logged in correctly!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                userNotifier.signOut();
              },
            ),
            Text('Sips Today'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await _fetchStats();
            },
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: notifier.drinks.length,
                itemBuilder: (context, index) {
                  final drink = notifier.drinks[index];
                  return DrinkTile(
                    drink: drink,
                    model: notifier,
                    key: ValueKey(drink.name + drink.sips.toString()),
                  );
                },
              ),
      ),
    );
  }
}

class DrinkTile extends StatefulWidget {
  const DrinkTile({
    super.key,
    required this.drink,
    required this.model,
  });

  final Drinks drink;
  final DrinkChangeNotifier model;

  @override
  State<DrinkTile> createState() => _DrinkTileState();
}

class _DrinkTileState extends State<DrinkTile> {
  Uri? imageUrl;

  @override
  void initState() {
    super.initState();
    unsplashClient.photos
        .random(
          query: "glass of ${widget.drink.name}",
          orientation: PhotoOrientation.squarish,
        )
        .goAndGet()
        .then((photo) {
      setState(() {
        imageUrl = photo.first.urls.thumb;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.drink.name),
      subtitle: Text('${widget.drink.sips} sips'),
      leading: SizedBox(
        width: 56,
        child: imageUrl == null
            ? null
            : Image.network(
                imageUrl.toString(),
                fit: BoxFit.cover,
              ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          widget.model.sip(widget.drink.name);
        },
      ),
    );
  }
}

class Drinks {
  final String name;
  final int sips;

  const Drinks({
    required this.name,
    required this.sips,
  });
}

final unsplashClient = UnsplashClient(
  settings: ClientSettings(
    credentials: AppCredentials(
      accessKey: '1afc67cd51a21845c38e3bf0607ebed60452c690191f40dadfa60c287dbd881b',
    ),
  ),
);
