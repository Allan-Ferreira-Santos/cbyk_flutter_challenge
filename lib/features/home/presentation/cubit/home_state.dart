import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/helper/result_helper.dart';

class HomeState {
  const HomeState({
    this.user,
    this.result = const ResultHelper.initial(),
  });

  final UserEntity? user;
  final ResultHelper<void> result;

  HomeState copyWith({
    UserEntity? user,
    ResultHelper<void>? result,
  }) {
    return HomeState(
      user: user ?? this.user,
      result: result ?? this.result,
    );
  }
}
