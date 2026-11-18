import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget child) async {
    await pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: child,
      ),
    );
  }

  Future<void> pumpScaffold(Widget child) async {
    await pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: child),
      ),
    );
  }

  void useViewport(Size size) {
    view.physicalSize = size;
    view.devicePixelRatio = 1;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  Future<void> settleToasts() async {
    await pump(const Duration(milliseconds: 2600));
    await pump(const Duration(milliseconds: 500));
  }
}
