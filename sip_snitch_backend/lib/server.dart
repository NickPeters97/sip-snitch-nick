import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class SipSnitchServer {
  final int port;
  HttpServer? _httpServer;

  // Map für tägliche Speicherung der Sips
  final Map<String, Map<String, int>> _dailySips = {};

  SipSnitchServer({required this.port});

  Future<void> start() async {
    final router = Router()
      ..post('/sip', _addSipHandler)
      ..get('/stats', _getStatsHandler)
      ..get('/today-stats', _getTodayStatsHandler); // Neuer Endpoint hinzugefügt

    final handler = Pipeline().addMiddleware(logRequests()).addHandler(router.call);

    final ip = InternetAddress.anyIPv4;
    _httpServer = await serve(handler, ip, port);
    print('Server running on http://${_httpServer!.address.host}:${_httpServer!.port}');
  }

  Future<void> stop() async {
    if (_httpServer != null) {
      await _httpServer!.close(force: true);
      _httpServer = null;
    }
  }

  Future<Response> _addSipHandler(Request request) async {
    final payload = await request.readAsString();
    final body = Uri.splitQueryString(payload);

    final drink = body['name'];
    if (drink == null || drink.isEmpty) {
      return Response(400, body: 'Drink name is required');
    }

    final today = DateTime.now().toIso8601String().split('T').first;

    _dailySips[today] ??= {};
    _dailySips[today]![drink] = (_dailySips[today]![drink] ?? 0) + 1;

    return Response.ok('Added a sip of $drink');
  }

  Response _getStatsHandler(Request request) {
    final stats = {
      for (final entry in _dailySips.entries)
        entry.key: {for (final drink in entry.value.entries) drink.key: drink.value}
    };
    return Response.ok(jsonEncode(stats), headers: {'Content-Type': 'application/json'});
  }

  Response _getTodayStatsHandler(Request request) {
    final today = DateTime.now().toIso8601String().split('T').first;

    final todayStats = _dailySips[today] ?? {};
    return Response.ok(jsonEncode(todayStats), headers: {'Content-Type': 'application/json'});
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
