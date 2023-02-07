import 'package:deltaplan/features/all_events/domain/entities/participant.dart';

class UserEvent {
  int? id;
  String? name;
  String? category;
  String? description;
  String? dateStart;
  String? dateEnd;
  String? reminder;
  List<String>? documents;
  List<Participant>? participants;

  UserEvent({
    this.id,
    this.name,
    this.category,
    this.description,
    this.dateStart,
    this.dateEnd,
    this.reminder,
    this.documents,
    this.participants,
  });
}
