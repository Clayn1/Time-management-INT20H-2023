import 'package:deltaplan/core/error/failures.dart';
import 'package:deltaplan/core/error/repository_request_handler.dart';
import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/all_events/data/datasource/events_datasource.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/domain/repositories/events_repository.dart';
import 'dart:io';

class EventsRepositoryImpl implements EventsRepository {
  final EventsDatasource datasource;

  EventsRepositoryImpl({required this.datasource});

  @override
  FutureFailable<List<UserEvent>> getEvents(
      String query, List<String> filters) {
    return RepositoryRequestHandler<List<UserEvent>>()(
      request: () => datasource.getEvents(query, filters),
      defaultFailure: Failure(),
    );
  }

  @override
  FutureFailable<UserEvent> addEvent(
      UserEvent event, List<String> participants, List<File> files) {
    return RepositoryRequestHandler<UserEvent>()(
      request: () => datasource.addEvent(event, participants, files),
      defaultFailure: Failure(),
    );
  }

  @override
  FutureFailable<UserEvent> editEvent(
      int id, UserEvent event, List<String> participants, List<File> files) {
    return RepositoryRequestHandler<UserEvent>()(
      request: () => datasource.editEvent(id, event, participants, files),
      defaultFailure: Failure(),
    );
  }

  @override
  FutureFailable<bool> deleteEvent(int id) {
    return RepositoryRequestHandler<bool>()(
      request: () => datasource.deleteEvent(id),
      defaultFailure: Failure(),
    );
  }
}
