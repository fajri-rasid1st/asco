// Dart imports:
import 'dart:io';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';

class FileService {
  static Future<String?> downloadFile({
    required String url,
    bool flush = false,
  }) async {
    try {
      // Create request
      final response = await HttpClient.client.get(Uri.parse(url));

      // Get application directory
      final directory = await getApplicationDocumentsDirectory();

      // Define file name
      final name = p.basename(url);

      // Writes a list of bytes to a file
      final file = await File('${directory.path}/$name').writeAsBytes(
        response.bodyBytes,
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
