import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

const _allowedDrinks = ['Water', 'Coffee', 'RedBull', 'Club Mate', 'Beer'];

class SipSnitchServer {
  final int port;
  HttpServer? _httpServer;
  final Map<String, int> _sips = {};

  SipSnitchServer({required this.port});

  Future<HttpServer> start() async {
    final router = Router()
      ..post('/sip', _addSipHandler)
      ..get('/stats', _getStatsHandler);

    final handler = Pipeline().addMiddleware(logRequests()).addHandler(router.call);

    final ip = InternetAddress.anyIPv4;
    _httpServer = await serve(handler, ip, port);
    print('Server running on http://${_httpServer!.address.host}:${_httpServer!.port}');

    return _httpServer!;
  }

  Future<void> stop() async {
    if (_httpServer != null) {
      await _httpServer!.close(force: true);
      _httpServer = null;
    }
  }

  Future<Response> _addSipHandler(Request request) async {
    final payload = await request.readAsString();
    final body = jsonDecode(payload) as Map<String, dynamic>;

    final drink = '${body['name']}';
    final isAllowedDrink = _allowedDrinks.contains(drink);

    if (!isAllowedDrink) {
      throw Exception('Drink $drink is not allowed');
    }

    _sips[drink] = (_sips[drink] ?? 0) + 1;

    return Response.ok('Added a sip of $drink');
  }

  Response _getStatsHandler(Request request) {
    final stats = {for (final entry in _sips.entries) entry.key: entry.value};
    return Response.ok(jsonEncode(stats), headers: {'Content-Type': 'application/json'});
  }

  HttpServer get httpServer {
    if (_httpServer == null) {
      throw Exception('Server not started');
    }
    return _httpServer!;
  }

  InternetAddress get address {
    if (_httpServer == null) {
      throw Exception('Server not started');
    }
    return _httpServer!.address;
  }
}
