import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:sip_snitch_backend/server.dart';
import 'package:test/test.dart';

late SipSnitchServer server;
final port = '8081';
String get host => 'http://${server.httpServer.address.host}:${server.httpServer.port}';

void main() {
  setUp(() async {
    server = SipSnitchServer(port: int.parse(port));
    await server.start();
  });

  tearDown(() => server.stop());

  test('successful sip', () async {
    final response = await post(Uri.parse('$host/sip'), body: jsonEncode({'name': 'Water'}));
    expect(response.body, 'Added a sip of Water');
    expect(response.statusCode, 200);
  });

  test('not allowed drink', () async {
    final response = await post(Uri.parse('$host/sip'), body: jsonEncode({'name': 'Cola'}));
    expect(response.body, 'Drink Cola is not allowed');
    expect(response.statusCode, 400);
  });
}
