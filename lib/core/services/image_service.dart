// Dart imports:
import 'dart:typed_data';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class ImageService {
  static Future<String?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: source);

    return image?.path;
  }

  static Future<String?> cropImage({
    required String imagePath,
    CropAspectRatio? aspectRatio,
  }) async {
    final ImageCropper cropper = ImageCropper();

    final CroppedFile? croppedImage = await cropper.cropImage(
      sourcePath: imagePath,
      aspectRatio: aspectRatio,
      maxWidth: 500,
      maxHeight: 500,
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Gambar',
          toolbarColor: Palette.purple2,
          toolbarWidgetColor: Palette.background,
          activeControlsWidgetColor: Palette.purple3,
          backgroundColor: Palette.scaffoldBackground,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Crop Gambar',
          doneButtonTitle: 'Selesai',
          cancelButtonTitle: 'Batal',
          resetAspectRatioEnabled: false,
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    return croppedImage?.path;
  }

  static Future<Uint8List> capturePngImage(BuildContext context) async {
    final boundary = context.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    return pngBytes;
  }
}
