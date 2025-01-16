import 'dart:convert';
import 'dart:io';

import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

const _allowedDrinks = ['Water', 'Coffee', 'RedBull', 'Club Mate', 'Beer'];

late FirebaseAdminApp admin;

class SipSnitchServer {
  final int port;
  HttpServer? _httpServer;
  final Map<String, int> _sips = {};

  SipSnitchServer({required this.port});

  Future<HttpServer> start() async {
    admin = FirebaseAdminApp.initializeApp(
      'drink-track',
      // This will obtain authentication information from the environment
      Credential.fromApplicationDefaultCredentials(),
    );

    final router = Router()
      ..post('/sip', _addSipHandler)
      ..get('/stats', _getStatsHandler)
      ..get('/greet/<name>', _greetingHandler)
      ..post('/greet2', _greetingHandlerPost);

    final handler = Pipeline().addMiddleware(logRequests()).addHandler(router.call);
    // Pipeline().addMiddleware(logRequests()).addMiddleware(firebaseAuthMiddleware()).addHandler(router.call);

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
      return Response(400, body: 'Drink $drink is not allowed!!!');
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

  Response _greetingHandler(Request request) {
    final name = request.params['name'] ?? 'PHNTM';

    print('Hello $name');
    return Response.ok('Hello $name');
  }

  Future<Response> _greetingHandlerPost(Request request) async {
    try {
      final payload = await request.readAsString();
      final body = jsonDecode(payload) as Map<String, dynamic>;

      final name = body['name'] ?? 'PHNTM';

      print('Hello $name');
      return Response.ok('Hello $name');
    } catch (e) {
      return Response.internalServerError(body: 'Invalid request: $e');
    }
  }
}

Middleware firebaseAuthMiddleware() {
  final auth = Auth(admin);

  return (Handler innerHandler) {
    return (Request request) async {
      try {
        // Extract the Authorization header
        final authHeader = request.headers['authorization'];
        if (authHeader == null || !authHeader.startsWith('Bearer ')) {
          return Response.forbidden('Missing or invalid Authorization header');
        }

        // Extract the token
        final idToken = authHeader.substring(7); // Remove "Bearer " prefix

        // Verify the token
        final decodedToken = await auth.verifyIdToken(idToken);

        // Add the decoded token to the request context
        final context = Map<String, Object?>.from(request.context)..['firebaseUser'] = decodedToken;

        // Forward the request with the updated context
        return await innerHandler(request.change(context: context));
      } catch (e) {
        // Handle token verification errors
        throw 'Invalid Firebase token: $e';
      }
    };
  };
}
