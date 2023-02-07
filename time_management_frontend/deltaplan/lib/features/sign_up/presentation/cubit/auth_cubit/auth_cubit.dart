import 'package:bloc/bloc.dart';
import 'package:deltaplan/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/token_local_repository.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository}) : super(AuthInitial());
  final TokenLocalRepository repository;

  Future checkIfUserAuthorized() async {
    final result = await sl<UserCubit>().repository.getUser();
    //print(await repository.getToken());
    emit(result.fold((error) => AuthFailure(), (data) {
      return AuthSuccess();
    }));
  }

  Future saveUserSession(String token) async {
    await repository.saveToken(token);
    emit(AuthSuccess());
  }

  Future removeUserSession() async {
    await repository.deleteToken();
    emit(AuthFailure());
  }
}
