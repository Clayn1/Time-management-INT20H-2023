part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserSuccess extends UserState {
  final User user;

  UserSuccess({required this.user});
}

class UserFailure extends UserState {}

class UserLoading extends UserState {}
