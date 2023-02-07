import 'package:deltaplan/features/all_events/data/datasource/events_datasource.dart';
import 'package:deltaplan/features/all_events/data/repositories/events_repository_impl.dart';
import 'package:deltaplan/features/all_events/domain/repositories/events_repository.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/add_event/add_event_cubit.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/all_events/all_events_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:dio/dio.dart';

mixin AllEventsInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);
    // cubits
    sl.registerLazySingleton<AllEventsCubit>(
        () => AllEventsCubit(repository: sl()));
    sl.registerLazySingleton<AddEventCubit>(
        () => AddEventCubit(repository: sl()));

    // use cases

    // repositories
    sl.registerLazySingleton<EventsRepository>(
        () => EventsRepositoryImpl(datasource: sl()));

    // data sources
    sl.registerLazySingleton<EventsDatasource>(
        () => EventsDatasourceImpl(dio: dio));
  }
}
