import 'package:deltaplan/features/invites/domain/entities/invite.dart';
import 'package:dio/dio.dart';

import 'models/invite_model.dart';

abstract class InviteDatasource {
  Future<bool> acceptInvite(int id);
  Future<bool> declineInvite(int id);
  Future<List<Invite>> getInvites();
}

class InviteDatasourceImpl implements InviteDatasource {
  final Dio dio;

  InviteDatasourceImpl({required this.dio});

  @override
  Future<List<Invite>> getInvites() async {
    final response = await dio.get(
      '/invitation',
    );
    List<Invite> invites = [];
    for (var invite in response.data) {
      invites.add(InviteModel.fromJson(invite));
    }
    return invites;
  }

  @override
  Future<bool> acceptInvite(int id) async {
    final response = await dio.post(
      '/invitation/$id/accept',
    );
    return true;
  }

  @override
  Future<bool> declineInvite(int id) async {
    final response = await dio.post(
      '/invitation/$id/decline',
    );
    return true;
  }
}
