// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';

class FileService {
  static Future<String?> downloadFile(
    String url, {
    bool flush = false,
  }) async {
    try {
      final response = await HttpClient.client.get(Uri.parse(url));

      final directory = await getTemporaryDirectory();

      final fileName = p.basename(url);

      final file = await File('${directory.path}/$fileName').writeAsBytes(
        response.bodyBytes,
        flush: flush,
      );

      return file.path;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> createFile(
    Uint8List bytes, {
    bool flush = false,
    required String extension,
    String? name,
  }) async {
    try {
      final directory = await getTemporaryDirectory();

      final fileName = name ?? '${const Uuid().v4()}.$extension';

      final file = await File('${directory.path}/$fileName').writeAsBytes(
        bytes,
        flush: flush,
      );

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
}
