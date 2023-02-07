import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/invites/domain/entities/invite.dart';

abstract class InviteRepository {
  FutureFailable<bool> acceptInvite(int id);
  FutureFailable<bool> declineInvite(int id);
  FutureFailable<List<Invite>> getInvites();
}