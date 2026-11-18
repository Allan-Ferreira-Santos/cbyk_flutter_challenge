import 'app_colors.dart';
import 'package:flutter/material.dart';


class AppGradients {
  static const LinearGradient hero = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0E7C78),
      Color(0xFF1FA8A0),
      Color(0xFFB8D44A),
      Color(0xFFE8D44D),
    ],
  );

  static const LinearGradient heroDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A6B68), Color(0xFF1FA8A0), Color(0xFFC5DB4E)],
  );

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.teal, AppColors.tealBright, Color(0xFF9CCC65)],
  );

  static const LinearGradient helpBanner = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.teal, AppColors.lime],
  );
}
