// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/utils/http_client.dart';

class FileService {
  static Future<String?> downloadFile(String url) async {
    try {
      final response = await HttpClient.client.get(Uri.parse(url));
      final directory = await getTemporaryDirectory();
      final fileName = p.basename(url);
      final file = await File('${directory.path}/$fileName').writeAsBytes(response.bodyBytes);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveFileFromAsset(String assetName) async {
    try {
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

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> createFile(
    Uint8List bytes, {
    required String extension,
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

  static Future<void> openFile(String path) async => await OpenFile.open(path);
}
