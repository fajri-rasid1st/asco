// Package imports:
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';

class ImageService {
  static Future<String?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    return image?.path;
  }

  static Future<String?> cropImage({
    required String imagePath,
    CropAspectRatio? aspectRatio,
  }) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: aspectRatio,
      maxWidth: 500,
      maxHeight: 500,
      compressQuality: 70,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Gambar',
          toolbarColor: primaryColor,
          toolbarWidgetColor: scaffoldBackgroundColor,
          activeControlsWidgetColor: primaryColor,
          backgroundColor: scaffoldBackgroundColor,
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

    return croppedFile?.path;
  }
}
