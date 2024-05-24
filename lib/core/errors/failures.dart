// Package imports:
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

// Project imports:
import 'package:law_app/core/errors/exceptions.dart';
import 'package:law_app/core/utils/const.dart';

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
      case kUnauthorized:
        return const ServerFailure(kUnauthorized);
      case kUsernameAlreadyExist:
        return const ServerFailure('Username telah digunakan');
      case kEmailAlreadyExist:
        return const ServerFailure('Email telah digunakan');
      case kUserNotFound:
        return const ServerFailure('Akun belum terdaftar');
      case kWrongPassword:
        return const ServerFailure('Password salah');
      case kAdTitleAlreadyExist:
        return const ServerFailure('Telah terdapat iklan yang sama');
      case kCategoryAlreadyExist:
        return const ServerFailure('Telah terdapat kategori yang sama');
      case kGlossaryAlreadyExist:
        return const ServerFailure('Telah terdapat kosa kata yang sama');
      case kNoGeneralQuestionLeft:
        return const ServerFailure('Kuota pertanyaan umum telah habis');
      case kNoSpecificQuestionLeft:
        return const ServerFailure('Kuota pertanyaan khusus telah habis');
      case kOptionAnswerNotFound:
        return const ServerFailure('Tidak ada opsi jawaban benar');
      case kratingAlreadyExist:
        return const ServerFailure('Kamu telah memberi ulasan pada course ini');
      default:
        return ServerFailure(e.message);
    }
  }

  return ClientFailure((e as ClientException).message);
}
