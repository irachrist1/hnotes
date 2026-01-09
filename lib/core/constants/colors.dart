import 'package:flutter/material.dart';

/// App color palette inspired by LOGLINE branding
/// Sky blue gradient theme
class AppColors {
  // Primary Colors
  static const Color skyBlue = Color(0xFF1792DB);
  static const Color deepBlue = Color(0xFF1F3DBD);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF141414);

  // Gradient
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepBlue, skyBlue],
  );

  // Horizontal gradient (for variety)
  static const LinearGradient blueGradientHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [deepBlue, skyBlue],
  );
}
