// Package imports:
import 'package:http/http.dart';

/// Exception class that will be thrown when there is a problem
/// related to the server.
class ServerException implements Exception {
  final String? code;
  final String? message;

  const ServerException(this.code, this.message);
}

/// Exception class that will be thrown when there is a problem
/// related to shared preferences.
class PreferencesException implements Exception {
  final String? message;

  const PreferencesException(this.message);
}

Never exception(Object e) {
  if (e is ServerException) {
    throw ServerException(e.code, e.message);
  } else {
    throw ClientException(e.toString());
  }
}
