import 'package:flutter_test/flutter_test.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_cubit.dart';

void main() {
  late WebViewCubit cubit;

  setUp(() {
    cubit = WebViewCubit();
  });

  tearDown(() async => cubit.close());

  test('load com URL válida marca success', () {
    cubit.load(title: 'Automóvel', url: 'https://jsonplaceholder.typicode.com/');

    expect(cubit.state.result.isSuccess, isTrue);
    expect(cubit.state.title, 'Automóvel');
    expect(cubit.state.url, 'https://jsonplaceholder.typicode.com/');
    expect(cubit.state.isPageLoading, isTrue);
  });

  test('load com URL inválida marca error', () {
    cubit.load(title: 'X', url: 'notaurl');

    expect(cubit.state.result.isError, isTrue);
    expect(cubit.state.isPageLoading, isFalse);
  });

  test('callbacks de página atualizam estado', () {
    cubit.load(title: 'A', url: 'https://example.com');
    cubit.markNativeControllerReady();
    cubit.onProgress(40);
    cubit.onPageStarted();
    expect(cubit.state.hasNativeController, isTrue);
    expect(cubit.state.progress, 40);
    expect(cubit.state.isPageLoading, isTrue);

    cubit.onPageFinished();
    expect(cubit.state.isPageLoading, isFalse);

    cubit.onWebResourceError('falha');
    expect(cubit.state.result.isError, isTrue);
    expect(cubit.state.result.descriptionMessage, 'falha');
  });
}
