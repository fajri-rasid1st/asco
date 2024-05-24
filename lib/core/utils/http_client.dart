// Package imports:
import 'package:http/http.dart' as http;

class HttpClient {
  static HttpClient? _instance;

  HttpClient._internal() {
    _instance = this;
  }

  factory HttpClient() => _instance ?? HttpClient._internal();

  static http.Client? _client;

  static http.Client get client {
    return _client ??= http.Client();
  }
}
