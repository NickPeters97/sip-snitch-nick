import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class SipSnitchServer {
  final int port;
  HttpServer? _httpServer;

  SipSnitchServer({
    required this.port,
  });

  Future<void> start() async {
    // Configure routes.
    final router = Router()
      ..get('/', _rootHandler)
      ..get('/echo/<message>', _echoHandler);
    // TODO move new endpoints to separate files

    // Configure a pipeline that logs requests.
    final handler =
        Pipeline().addMiddleware(logRequests()).addHandler(router.call);

    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.anyIPv4;
    // For running in containers, we respect the PORT environment variable.
    _httpServer = await serve(handler, ip, port);
  }

  Future<void> stop() async {
    if (_httpServer != null) {
      await _httpServer!.close(force: true);
      _httpServer = null;
    }
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

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}
