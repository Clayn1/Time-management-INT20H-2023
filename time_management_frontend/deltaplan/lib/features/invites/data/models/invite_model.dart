import 'package:deltaplan/features/invites/domain/entities/invite.dart';

class InviteModel extends Invite {

  InviteModel(
      {super.invitationId,
        super.status,
        super.email,
        super.eventId,
        super.eventName,
        super.category,
        super.dateStart,
        super.dateEnd});

  InviteModel.fromJson(Map<String, dynamic> json) {
    invitationId = json['invitationId'];
    status = json['status'];
    email = json['email'];
    eventId = json['eventId'];
    eventName = json['eventName'];
    category = json['category'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invitationId'] = this.invitationId;
    data['status'] = this.status;
    data['email'] = this.email;
    data['eventId'] = this.eventId;
    data['eventName'] = this.eventName;
    data['category'] = this.category;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    return data;
  }
}