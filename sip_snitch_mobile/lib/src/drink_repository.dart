import 'package:http/http.dart' as http;
import 'dart:convert';

class DrinkRepository {
  const DrinkRepository();

  String get backendUrl => 'http://localhost:8080';

  Future<void> addSip(String drinkName) async {
    try {
      final response = await http.post(
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
      final response = await http.get(Uri.parse('$backendUrl/stats'));

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
