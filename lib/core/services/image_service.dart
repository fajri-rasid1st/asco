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
          toolbarColor: purple2,
          toolbarWidgetColor: backgroundColor,
          activeControlsWidgetColor: purple3,
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

    return croppedImage?.path;
  }
}
