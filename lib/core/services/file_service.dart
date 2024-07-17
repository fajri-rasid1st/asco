// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:asco/core/configs/api_configs.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/data_response.dart';
import 'package:asco/core/utils/http_client.dart';

class FileService {
  static Future<String?> uploadFile(String path) async {
    try {
      final file = await http.MultipartFile.fromPath('file', path);

      final request = http.MultipartRequest('POST', Uri.parse('${ApiConfigs.baseUrl}/files'))
        ..files.add(file)
        ..headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data'
        ..headers[HttpHeaders.authorizationHeader] = 'Bearer ${CredentialSaver.accessToken}';

      final streamedResponse = await HttpClient.client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final result = DataResponse.fromJson(response.body);

      return result.data as String;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> downloadFile(String url) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = p.basename(url);
      final file = File('${directory.path}/$fileName');

      if (await file.exists()) return file.path;

      final response = await HttpClient.client.get(Uri.parse(url));
      final downloadedFile = await file.writeAsBytes(response.bodyBytes);

      return downloadedFile.path;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> createFile(
    List<int> bytes, {
    String? extension,
    String? name,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = name ?? '${const Uuid().v4()}.$extension';
      final file = await File('${directory.path}/$fileName').writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveFileFromUrl(
    String url, {
    String? name,
  }) async {
    try {
      final isPermitted = await FunctionHelper.requestPermission(
        await FunctionHelper.androidApiLevel >= 30
            ? Permission.manageExternalStorage
            : Permission.storage,
      );

      if (isPermitted) {
        var directory = await getDownloadsDirectory();

        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download/');

          if (!directory.existsSync()) {
            directory = Directory('/storage/emulated/0/Downloads/');
          }
        }

        final fileName = name ?? p.basename(url);
        final file = File('${directory?.path}/$fileName');
        final response = await HttpClient.client.get(Uri.parse(url));

        await file.create(recursive: true);
        await file.writeAsBytes(response.bodyBytes);
      }

      return isPermitted;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveFileFromRawBytes(
    List<int> bytes, {
    String? extension,
    String? name,
  }) async {
    try {
      final isPermitted = await FunctionHelper.requestPermission(
        await FunctionHelper.androidApiLevel >= 30
            ? Permission.manageExternalStorage
            : Permission.storage,
      );

      if (isPermitted) {
        var directory = await getDownloadsDirectory();

        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download/');

          if (!directory.existsSync()) {
            directory = Directory('/storage/emulated/0/Downloads/');
          }
        }

        final fileName = name ?? '${const Uuid().v4()}.$extension';
        final file = File('${directory?.path}/$fileName');

        await file.create(recursive: true);
        await file.writeAsBytes(bytes);
      }

      return isPermitted;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveFileFromAsset(String assetName) async {
    try {
      final isPermitted = await FunctionHelper.requestPermission(
        await FunctionHelper.androidApiLevel >= 30
            ? Permission.manageExternalStorage
            : Permission.storage,
      );

      if (isPermitted) {
        var directory = await getDownloadsDirectory();

        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download/');

          if (!directory.existsSync()) {
            directory = Directory('/storage/emulated/0/Downloads/');
          }
        }

        final file = File('${directory?.path}/$assetName');
        final byteData = await rootBundle.load(AssetPath.getFile(assetName));
        final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

        await file.create(recursive: true);
        await file.writeAsBytes(bytes);
      }

      return isPermitted;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> pickFile({required List<String> extensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensions,
      );

      return result?.files.single.path;
    } catch (e) {
      return null;
    }
  }

  static Future<void> openFile(String path, [bool isUrl = false]) async {
    if (isUrl) {
      final newPath = await downloadFile(path);

      if (newPath != null) await OpenFile.open(newPath);
    } else {
      await OpenFile.open(path);
    }
  }
}
