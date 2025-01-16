import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sip_snitch_mobile/src/authenticated_http_client.dart';

class DrinkRepository {
  DrinkRepository();

  // String get backendUrl => 'https://sip-snitch-backend-nick-394870284554.europe-west1.run.app';
  String get backendUrl => 'http://0.0.0.0:8080';

  final AuthenticatedHttpClient _client = AuthenticatedHttpClient(http.Client());

  Future<void> addSip(String drinkName) async {
    try {
      final response = await _client.post(
        Uri.parse('$backendUrl/sip'),
        body: jsonEncode({'name': drinkName}),
      );
      print(response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to add sip: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding sip: $e');
    }
  }

  Future<Map<String, int>> fetchStats() async {
    try {
      final response = await _client.get(Uri.parse('$backendUrl/stats'));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch stats: ${response.body}');
      }
      final String body = response.body;

      final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;
      return json.map((key, value) => MapEntry(key, value as int));
    } catch (e) {
      throw Exception('Error fetching stats: $e');
    }
  }
}
