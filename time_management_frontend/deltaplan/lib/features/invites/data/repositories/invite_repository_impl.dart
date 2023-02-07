import 'package:deltaplan/core/error/failures.dart';
import 'package:deltaplan/core/error/repository_request_handler.dart';
import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/invites/data/invite_datasource.dart';
import 'package:deltaplan/features/invites/domain/entities/invite.dart';
import 'package:deltaplan/features/invites/domain/repositories/invite_repository.dart';

class InviteRepositoryImpl implements InviteRepository {
  final InviteDatasource datasource;

  InviteRepositoryImpl({required this.datasource});

  @override
  FutureFailable<List<Invite>> getInvites() {
    return RepositoryRequestHandler<List<Invite>>()(
      request: () => datasource.getInvites(),
      defaultFailure: Failure(),
    );
  }

  @override
  FutureFailable<bool> acceptInvite(int id) {
    return RepositoryRequestHandler<bool>()(
      request: () => datasource.acceptInvite(id),
      defaultFailure: Failure(),
    );
  }

  @override
  FutureFailable<bool> declineInvite(int id) {
    return RepositoryRequestHandler<bool>()(
      request: () => datasource.declineInvite(id),
      defaultFailure: Failure(),
    );
  }
}
