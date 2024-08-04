import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

pickImage(ImageSource source, bool isXFile) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    if (isXFile) {
      return file;
    }
    return await file.readAsBytes();
  }
}

pickMultiImage() async {
  final ImagePicker imagePicker = ImagePicker();

  final List<XFile> selectedImages = await imagePicker.pickMultiImage();
  List<Uint8List>? images = [];
  if (selectedImages.isNotEmpty) {
    for (var image in selectedImages) {
      images.add(await fileToUint8List(image));
    }
  }

  return images;
}

Future<Uint8List> fileToUint8List(XFile file) async {
  return await file.readAsBytes();
}

Future<Uint8List> compressImage(Uint8List file) async {
  var result = await FlutterImageCompress.compressWithList(
    file,
    minHeight: 1920,
    minWidth: 1080,
    quality: 70,
  );
  return result;
}
