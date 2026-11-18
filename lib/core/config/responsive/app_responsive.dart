import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/config/responsive/app_breakpoints.dart';


class AppResponsive {
  AppResponsive(this.width);

  factory AppResponsive.of(BuildContext context) {
    return AppResponsive(MediaQuery.sizeOf(context).width);
  }

  factory AppResponsive.fromWidth(double width) => AppResponsive(width);

  final double width;

  bool get isMobile => width < AppBreakpoints.tablet;

  bool get isTablet =>
      width >= AppBreakpoints.tablet && width < AppBreakpoints.desktop;

  bool get isDesktop => width >= AppBreakpoints.desktop;

  T when<T>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}
