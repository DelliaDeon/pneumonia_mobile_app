import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  final ImagePicker _imagePicker;

  ImageHelper({
    ImagePicker? imagePicker,
  }) : _imagePicker = imagePicker ?? ImagePicker();

  // function to pick image(s) from gallery or camera.
  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 90,
    bool multiple = false  // picking multiple images
  }) async {
    if (multiple) {
      // return a list of multiple images
      final pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: imageQuality
      );
      return pickedFiles;
    }
    else{
      // pick a single image
      final pickedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );
      if (pickedImage != null){
        return [pickedImage];
      }
    }

    // if no image is picked
    return [];
  }

}