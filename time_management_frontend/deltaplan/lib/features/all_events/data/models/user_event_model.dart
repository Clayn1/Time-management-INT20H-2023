import 'package:deltaplan/features/all_events/data/models/participant_model.dart';
import 'package:deltaplan/features/all_events/domain/entities/participant.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';

class UserEventModel extends UserEvent {
  UserEventModel({
    super.id,
    super.name,
    super.category,
    super.description,
    super.dateStart,
    super.dateEnd,
    super.reminder,
    super.documents,
    super.participants,
  });

  UserEventModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    category = json['category'];
    description = json['description'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    reminder = json['reminder'];
    if (json['documents'] != null) {
      documents = <String>[];
      json['documents'].forEach((v) {
        documents!.add(v);
      });
    }
    if (json['participants'] != null) {
      participants = <Participant>[];
      json['participants'].forEach((v) {
        participants!.add(ParticipantModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.category;
    data['description'] = this.description;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['reminder'] = this.reminder;
    if (this.documents != null) {
      data['documents'] = this.documents!.map((v) => v).toList();
    }
    return data;
  }
}
