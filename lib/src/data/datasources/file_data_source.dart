// Dart imports:
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/errors/exceptions.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';

abstract class FileDataSource {
  /// Upload any file
  Future<String> uploadAnyFile(String path);
}

class FileDataSourceImpl implements FileDataSource {
  final http.Client client;

  FileDataSourceImpl({required this.client});

  @override
  Future<String> uploadAnyFile(String path) async {
    try {
      final file = await http.MultipartFile.fromPath('file', path);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfigs.baseUrl}/files'),
      )
        ..files.add(file)
        ..headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data'
        ..headers[HttpHeaders.authorizationHeader] = 'Bearer ${CredentialSaver.accessToken}';

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(response.body);

      if (response.statusCode != 201) {
        throw ServerException(result.error?.code, result.error?.message);
      }

      return result.data as String;
    } catch (e) {
      exception(e);
    }
  }
}
