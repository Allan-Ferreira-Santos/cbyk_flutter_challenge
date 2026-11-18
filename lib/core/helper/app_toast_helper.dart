import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';

class AppToastHelper {
  static String? _lastKey;
  static DateTime? _lastShownAt;

  static const _debounce = Duration(milliseconds: 1000);
  static const _visibleFor = Duration(milliseconds: 2200);
  static const _animation = Duration(milliseconds: 350);

  static void show(String title, String message) {
    final key = '$title|$message';
    final now = DateTime.now();
    if (_lastKey == key &&
        _lastShownAt != null &&
        now.difference(_lastShownAt!) < _debounce) {
      return;
    }

    _lastKey = key;
    _lastShownAt = now;

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surfaceElevated,
      colorText: Colors.white,
      duration: _visibleFor,
      animationDuration: _animation,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeOutCubic,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      isDismissible: true,
    );
  }
}
