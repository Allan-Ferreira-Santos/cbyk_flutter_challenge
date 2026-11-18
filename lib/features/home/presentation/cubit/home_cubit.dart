import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';
import 'package:cbyk_flutter_challenge/core/exceptions/app_exception.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_state.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/logout_use_case.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/app_message_exception_mapper.dart';
import 'package:cbyk_flutter_challenge/features/home/domain/use_cases/get_current_user_use_case.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _logoutUseCase = logoutUseCase,
       super(HomeState(user: getCurrentUserUseCase()));

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  void load() {
    try {
      final user = _getCurrentUserUseCase();
      emit(state.copyWith(user: user, result: const ResultHelper.initial()));
    } catch (error) {
      emit(
        state.copyWith(
          result: ResultHelper.error(
            titleMessage: HomePageMapper.loadErrorTitle,
            descriptionMessage: _messageFromError(error),
          ),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(result: ResultHelper.loading()));
    try {
      await _logoutUseCase();
      emit(state.copyWith(result: ResultHelper.success()));
    } catch (error) {
      emit(
        state.copyWith(
          result: ResultHelper.error(
            titleMessage: HomePageMapper.logoutErrorTitle,
            descriptionMessage: _messageFromError(error),
          ),
        ),
      );
    }
  }

  String _messageFromError(Object error) {
    if (error is AppException) return error.message;
    return AppMessageExceptionMapper.unknownError;
  }
}
