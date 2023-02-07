part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String token;

  SignInSuccess({required this.token});
}

class SignInFailure extends SignInState {
  final String message;

  SignInFailure({required this.message});
}
