import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/my_color.dart';

Future<Uint8List?> cropImage(XFile imageFile) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 80,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: gradient1,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          activeControlsWidgetColor: gradient1,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ]);
  if (croppedFile != null) {
    return await File(croppedFile.path).readAsBytes();
  } else {
    return null;
  }
}

Future<Uint8List?> cropProductImage(XFile imageFile) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 80,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x4,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: gradient1,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          activeControlsWidgetColor: gradient1,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ]);
  if (croppedFile != null) {
    return await File(croppedFile.path).readAsBytes();
  } else {
    return null;
  }
}

Future<Uint8List?> cropCoverImage(XFile imageFile) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 80,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio5x3,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: gradient1,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
          activeControlsWidgetColor: gradient1,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ]);
  if (croppedFile != null) {
    return await File(croppedFile.path).readAsBytes();
  } else {
    return null;
  }
}
