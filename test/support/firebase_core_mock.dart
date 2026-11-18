import 'package:firebase_core_platform_interface/test.dart';

class EchoFirebaseCoreHostApi implements TestFirebaseCoreHostApi {
  @override
  Future<List<CoreInitializeResponse>> initializeCore() async => [];

  @override
  Future<CoreInitializeResponse> initializeApp(
    String appName,
    CoreFirebaseOptions initializeAppRequest,
  ) async {
    return CoreInitializeResponse(
      name: appName,
      options: initializeAppRequest,
      pluginConstants: {},
    );
  }

  @override
  Future<CoreFirebaseOptions> optionsFromResource() async {
    throw UnimplementedError('optionsFromResource não é usado nos testes');
  }
}

void setupEchoFirebaseCoreMocks() {
  TestFirebaseCoreHostApi.setUp(EchoFirebaseCoreHostApi());
}
