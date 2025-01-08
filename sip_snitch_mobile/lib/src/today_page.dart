import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sip_snitch_mobile/src/drink_change_notifier.dart';
import 'package:unsplash_client/unsplash_client.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<DrinkChangeNotifier>();
    final drinks = model.drinks;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sips Today'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: drinks.length,
          itemBuilder: (context, index) {
            final drink = drinks[index];
            return DrinkTile(
              drink: drink,
              model: model,
              key: ValueKey(drink.name),
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
      accessKey:
          '1afc67cd51a21845c38e3bf0607ebed60452c690191f40dadfa60c287dbd881b',
    ),
  ),
);
