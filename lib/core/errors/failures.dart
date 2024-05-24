// Package imports:
import 'package:asco/core/errors/exceptions.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

/// A base Failure class.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ClientFailure extends Failure {
  const ClientFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class PreferencesFailure extends Failure {
  const PreferencesFailure(super.message);
}

Failure failure(Object e) {
  if (e is ServerException) {
    switch (e.message) {
      case '':
        return const ServerFailure('');
      default:
        return ServerFailure(e.message);
    }
  }

  return ClientFailure((e as ClientException).message);
}
