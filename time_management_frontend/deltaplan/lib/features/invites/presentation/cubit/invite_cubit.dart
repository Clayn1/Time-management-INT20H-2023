import 'package:bloc/bloc.dart';
import 'package:deltaplan/features/invites/domain/entities/invite.dart';
import 'package:deltaplan/features/invites/domain/repositories/invite_repository.dart';
import 'package:meta/meta.dart';

part 'invite_state.dart';

class InviteCubit extends Cubit<InviteState> {
  InviteCubit({required this.repository}) : super(InviteInitial());

  final InviteRepository repository;

  Future getInvites() async {
    final result = await repository.getInvites();
    emit(result.fold(
        (failure) => InviteFailure(
            message: failure.errorMessage, invites: state.invites),
        (data) => InviteSuccess(invites: data)));
  }

  Future acceptInvite(int id, int index) async {
    final result = await repository.acceptInvite(id);
    List<Invite> invites = [];
    for (var inv in state.invites) {
      invites.add(inv);
    }
    invites.removeAt(index);
    emit(InviteSuccess(invites: invites));
  }

  Future declineInvite(int id, int index) async {
    final result = await repository.declineInvite(id);
    List<Invite> invites = [];
    for (var inv in state.invites) {
      invites.add(inv);
    }
    invites.removeAt(index);
    emit(InviteSuccess(invites: invites));
  }
}
