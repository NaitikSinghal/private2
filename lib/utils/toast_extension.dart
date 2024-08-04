import 'package:flutter/material.dart';
import 'package:pherico/utils/toast.dart';

extension ToastExtension on BuildContext {
  void showToast(
    String text, {
    isError = false,
    Duration duration = const Duration(seconds: 3),
    Duration transitionDuration = const Duration(milliseconds: 250),
  }) {
    final overlayState = Overlay.of(this);
    final toast = OverlayEntry(
      builder: (_) => ToastWidget(
        text: text,
        transitionDuration: transitionDuration,
        duration: duration,
        isError: isError,
      ),
    );
    overlayState.insert(toast);
    Future.delayed(duration, toast.remove);
  }
}
