import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';

class WebViewState {
  const WebViewState({
    this.title = '',
    this.url = '',
    this.hasNativeController = false,
    this.isPageLoading = false,
    this.progress = 0,
    this.result = const ResultHelper.initial(),
  });

  final String title;
  final String url;
  final bool hasNativeController;
  final bool isPageLoading;
  final int progress;
  final ResultHelper<void> result;

  WebViewState copyWith({
    String? title,
    String? url,
    bool? hasNativeController,
    bool? isPageLoading,
    int? progress,
    ResultHelper<void>? result,
  }) {
    return WebViewState(
      title: title ?? this.title,
      url: url ?? this.url,
      hasNativeController: hasNativeController ?? this.hasNativeController,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      progress: progress ?? this.progress,
      result: result ?? this.result,
    );
  }
}
