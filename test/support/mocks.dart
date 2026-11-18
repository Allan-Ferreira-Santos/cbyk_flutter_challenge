import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/data/services/session_service.dart';
import 'package:cbyk_flutter_challenge/core/data/services/preferences_service.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/data_source/auth_data_source.dart';
import 'package:cbyk_flutter_challenge/features/auth/data/repositories/auth_repository.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/entities/login_entity.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_use_case.dart';
import 'package:cbyk_flutter_challenge/features/auth/domain/use_cases/login_with_google_use_case.dart';
import 'package:cbyk_flutter_challenge/features/home/data/data_source/home_data_source.dart';
import 'package:cbyk_flutter_challenge/features/home/data/repositories/home_repository.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/get_current_user_use_case.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/logout_use_case.dart';
import 'package:cbyk_flutter_challenge/features/register/data/data_source/register_data_source.dart';
import 'package:cbyk_flutter_challenge/features/register/data/repositories/register_repository.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/entities/register_entity.dart';
import 'package:cbyk_flutter_challenge/features/register/domain/use_cases/register_use_case.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/data_source/splash_data_source.dart';
import 'package:cbyk_flutter_challenge/features/splash/data/repositories/splash_repository.dart';
import 'package:cbyk_flutter_challenge/features/splash/domain/use_cases/check_session_use_case.dart';
import 'package:cbyk_flutter_challenge/features/webview/data/services/webview_service.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRegisterRepository extends Mock implements RegisterRepository {}

class MockHomeRepository extends Mock implements HomeRepository {}

class MockSplashRepository extends Mock implements SplashRepository {}

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockRegisterDataSource extends Mock implements RegisterDataSource {}

class MockHomeDataSource extends Mock implements HomeDataSource {}

class MockSplashDataSource extends Mock implements SplashDataSource {}

class MockPreferencesService extends Mock implements PreferencesService {}

class MockSessionService extends Mock implements SessionService {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLoginWithGoogleUseCase extends Mock
    implements LoginWithGoogleUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockGetCurrentUserUseCase extends Mock
    implements GetCurrentUserUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements User {}

class MockWebViewService extends Mock implements WebViewService {}

void registerFallbackValues() {
  registerFallbackValue(
    const LoginEntity(email: 'a@b.c', password: '123456', cpf: '00000000000'),
  );
  registerFallbackValue(
    const RegisterEntity(
      email: 'a@b.c',
      password: '123456',
      name: 'Test',
      cpf: '00000000000',
    ),
  );
  registerFallbackValue(
    const UserEntity(
      id: '0',
      name: 'Test',
      cpf: '00000000000',
      email: 'a@b.c',
    ),
  );
  registerFallbackValue(<String, dynamic>{});
  registerFallbackValue((int _) {});
  registerFallbackValue(() {});
  registerFallbackValue((String _) {});
}
