part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String token;

  SignUpSuccess({required this.token});
}

class SignUpFailure extends SignUpState {
  final String message;

  SignUpFailure({required this.message});
}
