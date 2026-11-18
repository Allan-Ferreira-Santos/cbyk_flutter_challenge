import '../support/fakes.dart';
import '../support/fixtures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';
import 'package:cbyk_flutter_challenge/core/data/services/preferences_service.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/cubit/login_cubit.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_use_case.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_cubit.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/use_cases/register_use_case.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_with_google_use_case.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('integração: cadastro e login com remember', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = PreferencesService(
      await SharedPreferences.getInstance(),
    );
    final authRepository = FakeAuthRepository();
    final registerRepository = FakeRegisterRepository();

    final registerCubit = RegisterCubit(
      registerUseCase: RegisterUseCase(registerRepository),
    );
    registerCubit
      ..onNameChanged('Allan Ferreira')
      ..onCpfChanged(TestFixtures.validCpfMasked)
      ..onPasswordChanged('abcdef');
    await registerCubit.register();
    expect(registerCubit.state.submitResult.isSuccess, isTrue);
    expect(registerRepository.registerCalls, 1);

    final loginCubit = LoginCubit(
      loginUseCase: LoginUseCase(authRepository),
      loginWithGoogleUseCase: LoginWithGoogleUseCase(authRepository),
      preferencesService: preferences,
    );
    loginCubit
      ..onCpfChanged(TestFixtures.validCpfMasked)
      ..onPasswordChanged('abcdef')
      ..toggleRememberAlways(true);
    await loginCubit.login();

    expect(loginCubit.state.submitResult.isSuccess, isTrue);
    expect(preferences.rememberAlways, isTrue);
    expect(
      preferences.savedCpf,
      MaskInputHelper.unmaskCpf(TestFixtures.validCpfMasked),
    );

    await registerCubit.close();
    await loginCubit.close();
  });
}
