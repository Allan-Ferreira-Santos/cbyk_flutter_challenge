import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_cubit.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/modules/webview_module.dart';

void main() {
  setUp(() => Get.reset());
  tearDown(() => Get.reset());

  test('WebViewModule registra cubit', () {
    WebViewModule().dependencies();
    expect(Get.isRegistered<WebViewCubit>(), isTrue);
  });
}
