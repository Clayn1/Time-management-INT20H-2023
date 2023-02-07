import 'dart:convert';
import 'package:deltaplan/features/all_events/data/models/user_event_model.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:http_parser/http_parser.dart';

abstract class EventsDatasource {
  Future<List<UserEvent>> getEvents(String query, List<String> filters);
  Future<UserEvent> addEvent(
      UserEvent event, List<String> participants, List<File> files);
  Future<UserEvent> editEvent(
      int id, UserEvent event, List<String> participants, List<File> files);
  Future<bool> deleteEvent(int id);
}

class EventsDatasourceImpl implements EventsDatasource {
  final Dio dio;

  EventsDatasourceImpl({required this.dio});

  @override
  Future<List<UserEvent>> getEvents(String query, List<String> filters) async {
    final response = await dio.get(
      '/event?name=$query&category=${filters.join(',')}',
    );
    List<UserEvent> events = [];
    for (var event in response.data) {
      events.add(UserEventModel.fromJson(event));
    }
    return events;
  }

  @override
  Future<UserEvent> addEvent(
      UserEvent event, List<String> participants, List<File> files) async {
    List<MultipartFile> images = [];
    String fileName;
    for (int i = 0; i < files.length; i++) {
      fileName = files[i].path.split('/').last;
      images.add(MultipartFile.fromFileSync(
        files[i].path,
        filename: fileName,
      ));
    }
    FormData formData = FormData.fromMap({
      "event": MultipartFile.fromString(
        jsonEncode({
          "name": event.name,
          "category": event.category,
          if (event.description != null && event.description!.isNotEmpty)
            "description": event.description,
          "dateStart": event.dateStart,
          "dateEnd": event.dateEnd,
          if (event.reminder != null && event.reminder!.isNotEmpty)
            "reminder": event.reminder,
          "participants": participants,
        }),
        contentType: MediaType.parse('application/json'),
      ),
      "documents": images,
    });
    final response = await dio.post('/event', data: formData);
    return UserEventModel.fromJson(response.data);
  }

  @override
  Future<UserEvent> editEvent(int id, UserEvent event,
      List<String> participants, List<File> files) async {
    List<MultipartFile> images = [];
    String fileName;
    for (int i = 0; i < files.length; i++) {
      fileName = files[i].path.split('/').last;
      images
          .add(await MultipartFile.fromFile(files[i].path, filename: fileName));
    }
    FormData formData = FormData.fromMap({
      "event": MultipartFile.fromString(
        jsonEncode({
          "id": id,
          "name": event.name,
          "category": event.category,
          if (event.description != null && event.description!.isNotEmpty)
            "description": event.description,
          "dateStart": event.dateStart,
          "dateEnd": event.dateEnd,
          if (event.reminder != null && event.reminder!.isNotEmpty)
            "reminder": event.reminder,
          "participants": participants,
        }),
        contentType: MediaType.parse('application/json'),
      ),
      "documents": images,
    });
    final response = await dio.put('/event', data: formData);
    return UserEventModel.fromJson(response.data);
  }

  @override
  Future<bool> deleteEvent(int id) async {
    final response = await dio.delete(
      '/event/$id',
    );
    return true;
  }
}
