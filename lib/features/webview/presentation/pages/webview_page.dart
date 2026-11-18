import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/features/webview/data/services/webview_service.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_cubit.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_state.dart';
import 'package:cbyk_flutter_challenge/features/webview/utils/mappers/webview_page_mapper.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/widgets/webview_error_body.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    this.webViewService,
    @visibleForTesting this.forceWebBehavior,
  });

  final WebViewService? webViewService;
  final bool? forceWebBehavior;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final WebViewCubit _cubit = Get.find<WebViewCubit>();
  late final WebViewService _webViewService =
      widget.webViewService ?? WebViewService();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    final title = args is Map && args['title'] is String
        ? args['title'] as String
        : WebViewPageMapper.defaultTitle;
    final url = args is Map && args['url'] is String
        ? args['url'] as String
        : WebViewPageMapper.defaultUrl;

    _cubit.load(title: title, url: url);

    if (_cubit.state.result.isSuccess) {
      _createController(_cubit.state.url);
    }
  }

  void _createController(String url) {
    if (_webViewService.hasController || url.isEmpty) return;

    _webViewService.createController(
      url: url,
      onProgress: _cubit.onProgress,
      onPageStarted: _cubit.onPageStarted,
      onPageFinished: _cubit.onPageFinished,
      onError: _cubit.onWebResourceError,
    );
    _cubit.markNativeControllerReady();
    if (widget.forceWebBehavior ?? kIsWeb) {
      _cubit.onPageFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<WebViewCubit, WebViewState>(
        listener: (context, state) {
          if (state.result.isLoading) {
            _webViewService.reset();
            return;
          }

          if (state.result.isSuccess) {
            _createController(state.url);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Text(
                state.title.isEmpty
                    ? WebViewPageMapper.defaultTitle
                    : state.title,
              ),
            ),
            body: Stack(
              children: [
                _buildBody(state),
                if (state.isPageLoading && !(widget.forceWebBehavior ?? kIsWeb))
                  LinearProgressIndicator(
                    value: state.progress > 0 ? state.progress / 100 : null,
                    color: AppColors.tealBright,
                    backgroundColor: AppColors.surface,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(WebViewState state) {
    final result = state.result;

    if (result.isError) {
      return WebViewErrorBody(url: state.url, error: result.descriptionMessage);
    }

    if (result.isSuccess && state.hasNativeController) {
      return _webViewService.buildView();
    }

    return const Center(child: CircularProgressIndicator());
  }
}
