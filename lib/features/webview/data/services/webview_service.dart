import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewService {
  WebViewController? _controller;

  WebViewController? get controller => _controller;

  bool get hasController => _controller != null;

  void reset() => _controller = null;

  WebViewController createController({
    required String url,
    required void Function(int progress) onProgress,
    required VoidCallback onPageStarted,
    required VoidCallback onPageFinished,
    required void Function(String description) onError,
  }) {
    final controller = WebViewController();

    if (!kIsWeb) {
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: onProgress,
            onPageStarted: (_) => onPageStarted(),
            onPageFinished: (_) => onPageFinished(),
            onWebResourceError: (error) => onError(error.description),
          ),
        );
    }

    controller.loadRequest(Uri.parse(url));
    _controller = controller;
    return controller;
  }

  Widget buildView({Widget? loading}) {
    final controller = _controller;
    if (controller == null) {
      return loading ?? const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: controller);
  }
}
