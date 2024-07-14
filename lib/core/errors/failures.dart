// Package imports:
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/utils/const.dart';

/// A base Failure class.
abstract class Failure extends Equatable {
  final String? message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
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
      case kUnauthorized:
        return const ServerFailure('Akses tidak diizinkan');
      case kNoAuthorization:
        return const ServerFailure('Otorisasi tidak ada');
      case kAuthorizationExpired:
        return const ServerFailure('Sesi telah habis, harap login ulang');
      case kAuthorizationError:
        return const ServerFailure('Otorisasi error');
      case kUserNotFound:
        return const ServerFailure('Pengguna tidak ditemukan');
      case kIncorrectPassword:
        return const ServerFailure('Password yang dimasukkan salah');
      case kClassroomsEmpty:
        return const ServerFailure('Minimal harus terdapat 1 kelas yang ditambahkan');
      case kAssistantsEmpty:
        return const ServerFailure('Minimal harus terdapat 1 asisten yang ditambahkan');
      case kStudentsEmpty:
        return const ServerFailure('Minimal harus terdapat 1 siswa yang ditambahkan');
      default:
        return ServerFailure(e.message);
    }
  }

  return ClientFailure((e as ClientException).message);
}
