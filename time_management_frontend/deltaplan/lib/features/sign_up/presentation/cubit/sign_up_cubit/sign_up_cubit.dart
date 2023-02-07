import 'package:bloc/bloc.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.repository}) : super(SignUpInitial());

  final SignUpRepository repository;

  void setEmailValidationError() {
    emit(SignUpFailure(message: 'Invalid email format'));
  }

  Future signUp(String name, String email, String password) async {
    emit(SignUpLoading());
    final result = await repository.signUp(name, email, password);
    emit(result.fold((error) => SignUpFailure(message: error.errorMessage),
        (data) {
      if (data.isError == false) {
        return SignUpSuccess(token: data.token ?? '');
      } else {
        return SignUpFailure(
            message: data.errorMessage ?? 'Unexpected error occurred');
      }
    }));
  }
}
