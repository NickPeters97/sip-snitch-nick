import 'dart:io';

import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:sip_snitch_backend/server.dart';

Future<void> main(List<String> args) async {
  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = SipSnitchServer(port: port);

  // Handle signals for graceful shutdown.
  ProcessSignal.sigint.watch().listen((_) async {
    await server.stop();
    exit(1);
  });
  ProcessSignal.sigterm.watch().listen((_) async {
    await server.stop();
    exit(1);
  });
  await server.start();
  // withHotreload(() => server.start());
}
