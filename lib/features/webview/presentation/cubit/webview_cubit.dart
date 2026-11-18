import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_state.dart';
import 'package:cbyk_flutter_challenge/features/webview/utils/mappers/webview_page_mapper.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(const WebViewState());

  void load({required String title, required String url}) {
    emit(
      state.copyWith(
        result: ResultHelper.loading(),
        hasNativeController: false,
      ),
    );
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || uri.host.isEmpty) {
        throw FormatException('URL inválida: $url');
      }

      emit(
        state.copyWith(
          result: ResultHelper.success(),
          title: title,
          url: uri.toString(),
          hasNativeController: false,
          isPageLoading: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          result: ResultHelper.error(
            descriptionMessage: '${WebViewPageMapper.unavailablePrefix}$error',
          ),
          title: title,
          url: url,
          hasNativeController: false,
          isPageLoading: false,
        ),
      );
    }
  }

  void markNativeControllerReady() =>
      emit(state.copyWith(hasNativeController: true));

  void onProgress(int value) => emit(state.copyWith(progress: value));

  void onPageStarted() => emit(state.copyWith(isPageLoading: true));

  void onPageFinished() => emit(state.copyWith(isPageLoading: false));

  void onWebResourceError(String description) => emit(
    state.copyWith(
      result: ResultHelper.error(descriptionMessage: description),
      isPageLoading: false,
    ),
  );
}
