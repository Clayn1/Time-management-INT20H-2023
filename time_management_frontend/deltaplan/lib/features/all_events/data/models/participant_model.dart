import 'package:deltaplan/features/all_events/domain/entities/participant.dart';
import 'package:deltaplan/features/profile/data/models/user_model.dart';

class ParticipantModel extends Participant {

  ParticipantModel({super.id, super.status, super.user, super.issuedWhen});

  ParticipantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    issuedWhen = json['issuedWhen'];
  }

}