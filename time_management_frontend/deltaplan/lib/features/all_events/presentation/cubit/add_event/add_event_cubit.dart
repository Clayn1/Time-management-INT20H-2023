import 'package:bloc/bloc.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/domain/repositories/events_repository.dart';
import 'package:meta/meta.dart';
import 'dart:io';
part 'add_event_state.dart';

class AddEventCubit extends Cubit<AddEventState> {
  AddEventCubit({required this.repository}) : super(AddEventInitial());

  final EventsRepository repository;

  Future addEvent(
      UserEvent event, List<String> participants, List<File> files) async {
    emit(AddEventLoading());
    final result = await repository.addEvent(event, participants, files);
    emit(result.fold(
        (failure) => AddEventFailure(), (data) => AddEventSuccess()));
  }

  Future editEvent(int id, UserEvent event, List<String> participants,
      List<File> files) async {
    emit(AddEventLoading());
    final result = await repository.editEvent(id, event, participants, files);
    emit(result.fold(
        (failure) => AddEventFailure(), (data) => AddEventSuccess()));
  }

  Future deleteEvent(int id) async {
    emit(AddEventLoading());
    final result = await repository.deleteEvent(id);
    print(result);
    emit(result.fold(
        (failure) => AddEventFailure(), (data) => AddEventSuccess()));
  }
}
