import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/features/webview/presentation/cubit/webview_cubit.dart';


class WebViewModule extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebViewCubit>(() => WebViewCubit(), fenix: true);
  }
}
