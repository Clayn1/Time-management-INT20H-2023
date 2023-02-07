import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'dart:io';

abstract class EventsRepository {
  FutureFailable<List<UserEvent>> getEvents(String query, List<String> filters);
  FutureFailable<UserEvent> addEvent(
      UserEvent event, List<String> participants, List<File> files);
  FutureFailable<UserEvent> editEvent(
      int id, UserEvent event, List<String> participants, List<File> files);
  FutureFailable<bool> deleteEvent(int id);
}
