import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Athentication of the http client.
class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _client;

  AuthenticatedHttpClient(this._client);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final idToken = await user.getIdToken();
      print('Token: $idToken');
      request.headers['Authorization'] = 'Bearer $idToken';
    }
    return _client.send(request);
  }
}
