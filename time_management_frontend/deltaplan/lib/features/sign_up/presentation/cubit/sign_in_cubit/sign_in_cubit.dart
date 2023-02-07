import 'package:bloc/bloc.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/sign_in_repository.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.repository}) : super(SignInInitial());

  final SignInRepository repository;

  void setEmailValidationError() {
    emit(SignInFailure(message: 'Invalid email format'));
  }

  Future signIn(String email, String password) async {
    emit(SignInLoading());
    final result = await repository.signIn(email, password);
    emit(result.fold((error) => SignInFailure(message: error.errorMessage),
        (data) {
      if (data.isError == false) {
        return SignInSuccess(token: data.token ?? '');
      } else {
        return SignInFailure(
            message: data.errorMessage ?? 'Unexpected error occurred');
      }
    }));
  }

  Future setFirebaseToken(String token) async {
    final result = await repository.setFirebaseToken(token);
  }

  Future deleteFirebaseToken(String token) async {
    final result = await repository.deleteFirebaseToken(token);
  }
}
