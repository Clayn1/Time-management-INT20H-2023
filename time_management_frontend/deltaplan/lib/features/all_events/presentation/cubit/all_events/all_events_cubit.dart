import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:deltaplan/core/util/date_time_formatter.dart';
import 'package:deltaplan/features/all_events/domain/entities/participant.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/domain/repositories/events_repository.dart';
import 'package:deltaplan/features/profile/domain/entities/user.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:table_calendar/table_calendar.dart';

part 'all_events_state.dart';

class AllEventsCubit extends Cubit<AllEventsState> {
  AllEventsCubit({required this.repository}) : super(AllEventsLoading());

  final EventsRepository repository;

  void addSearchQuery(String query) {
    emit(AllEventsMain(
        query: query,
        filterCategories: state.filterCategories,
        eventGroups: state.eventGroups));
  }

  void addFilterCategory(String category) {
    List<String> categories = [];
    for (var cat in state.filterCategories) {
      categories.add(cat);
    }
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    emit(AllEventsMain(
        filterCategories: categories,
        query: state.query,
        eventGroups: state.eventGroups));
  }

  void signUpGoogleAndGetEvents() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [CalendarApi.calendarScope],
    );
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    CalendarApi calendar =
        CalendarApi((await googleSignIn.authenticatedClient())!);
    try {
      String calendarId = "primary";
      calendar.events.list(calendarId).then((value) async {
        Event e =
            await calendar.events.get(calendarId, value.items?[0].id ?? '');
        processGoogleEvents(value.items ?? []);
      });
    } catch (e) {
      log('Error creating event $e');
    }
  }

  void processGoogleEvents(List<Event> events) {
    List<UserEvent> appEvents = [];
    for (var event in events) {
      UserEvent newEvent = UserEvent(
        category: "GOOGLE",
        description: event.description,
        participants: getGoogleParticipantsEmails(event.attendees ?? []),
        documents: getGoogleAttachments(event.attachments ?? []),
        name: "Google calendar event",
        dateStart: DateTimeFormatter.getStringFromDate(
            event.start?.date ?? DateTime.now()),
        dateEnd: DateTimeFormatter.getStringFromDate(
            event.end?.date ?? DateTime.now()),
      );
      appEvents.add(newEvent);
    }
    getEvents(appEvents);
  }

  List<String> getGoogleAttachments(List<EventAttachment> attachments) {
    List<String> images = [];
    for (var attachment in attachments) {
      if ((attachment.mimeType == '.png' ||
              attachment.mimeType == '.jpg' ||
              attachment.mimeType == '.jpeg') &&
          attachment.fileUrl != null) {
        images.add(attachment.fileUrl!);
      }
    }
    return images;
  }

  List<Participant> getGoogleParticipantsEmails(List<EventAttendee> attendees) {
    List<Participant> participants = [];
    for (var attendee in attendees) {
      if (attendee.email != null) {
        participants.add(Participant(user: User(email: attendee.email!)));
      }
    }
    return participants;
  }

  Future getEvents([List<UserEvent> googleEvents = const []]) async {
    //emit(AllEventsLoading());
    final result =
        await repository.getEvents(state.query, state.filterCategories);
    emit(result.fold(
        (failure) => AllEventsFailure(
            message: failure.errorMessage,
            eventGroups: state.eventGroups,
            filterCategories: state.filterCategories,
            query: state.query), (data) {
      List<UserEvent> fetchedEvents = [];
      fetchedEvents.addAll(data);
      if (googleEvents.isNotEmpty) {
        fetchedEvents.addAll(googleEvents);
      }
      return AllEventsMain(
          eventGroups: getGroupedEvents(fetchedEvents),
          filterCategories: state.filterCategories,
          query: state.query);
    }));
  }

  Map<String, List<UserEvent>> getGroupedEvents(List<UserEvent> events) {
    Map<String, List<UserEvent>> groupedEvents = {};
    groupedEvents = groupBy(events, (o) => o.dateStart?.substring(0, 10) ?? '');
    return groupedEvents;
  }

  Map<String, List<UserEvent>> getGroupedByTimeEvents(List<UserEvent> events) {
    Map<String, List<UserEvent>> groupedEvents = {};
    groupedEvents =
        groupBy(events, (o) => o.dateStart?.substring(11, 13) ?? '');
    return groupedEvents;
  }

  List<UserEvent> getEventsForDay(
      Map<String, List<UserEvent>> eventGroups, DateTime day) {
    List<UserEvent> events = [];
    eventGroups.forEach((key, value) {
      if (isSameDay(day, DateTimeFormatter.getDateTimeFromString(key))) {
        events.addAll(value);
      }
    });

    return events;
  }

  bool isTimeMatch(String time, Iterable<String> times) {
    bool isMatch = false;
    for (var element in times) {
      if (element == time) {
        isMatch = true;
      }
    }
    return isMatch;
  }

  List<UserEvent> getMatchElements(
      String time, Map<String, List<UserEvent>> events) {
    List<UserEvent> matchingEvents = [];
    for (var element in events.keys) {
      if (element == time) {
        events[element]?.forEach((event) {
          matchingEvents.add(event);
        });
      }
    }
    return matchingEvents;
  }
}
