// Package imports:
import 'package:http/http.dart' as http;

/// Exception class that will be thrown when there is a problem
/// related to the server.
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

/// Exception class that will be thrown when there is a problem
/// related to shared preferences.
class PreferencesException implements Exception {
  final String message;

  const PreferencesException(this.message);
}

Never exception(Object e) {
  if (e is ServerException) {
    throw ServerException(e.message);
  } else {
    throw http.ClientException(e.toString());
  }
}
