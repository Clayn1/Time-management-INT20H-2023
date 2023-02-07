part of 'invite_cubit.dart';

@immutable
abstract class InviteState {
  final List<Invite> invites;

  const InviteState({this.invites = const []});
}

class InviteInitial extends InviteState {}

class InviteSuccess extends InviteState {
  const InviteSuccess({super.invites});
}

class InviteFailure extends InviteState {
  final String message;
  const InviteFailure({super.invites, required this.message});
}
