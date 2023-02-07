part of 'all_events_cubit.dart';

@immutable
abstract class AllEventsState {
  final List<String> filterCategories;
  final String query;
  final List<UserEvent> events;
  final Map<String, List<UserEvent>> eventGroups;

  const AllEventsState({
    this.filterCategories = const [],
    this.query = '',
    this.events = const [],
    this.eventGroups = const {},
  });
}

class AllEventsLoading extends AllEventsState {}

class AllEventsMain extends AllEventsState {
  const AllEventsMain({
    super.filterCategories,
    super.query,
    super.events,
    super.eventGroups,
  });
}

class AllEventsFailure extends AllEventsState {
  final String message;

  const AllEventsFailure(
      {required this.message,
      super.filterCategories,
      super.query,
      super.eventGroups});
}
