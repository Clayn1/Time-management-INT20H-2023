import 'package:deltaplan/features/all_events/data/datasource/events_datasource.dart';
import 'package:deltaplan/features/all_events/data/repositories/events_repository_impl.dart';
import 'package:deltaplan/features/all_events/domain/repositories/events_repository.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/add_event/add_event_cubit.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/all_events/all_events_cubit.dart';
import 'package:deltaplan/features/invites/data/invite_datasource.dart';
import 'package:deltaplan/features/invites/data/repositories/invite_repository_impl.dart';
import 'package:deltaplan/features/invites/presentation/cubit/invite_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:dio/dio.dart';

import 'domain/repositories/invite_repository.dart';

mixin InviteInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);
    // cubits
    sl.registerLazySingleton<InviteCubit>(() => InviteCubit(repository: sl()));

    // use cases

    // repositories
    sl.registerLazySingleton<InviteRepository>(
        () => InviteRepositoryImpl(datasource: sl()));

    // data sources
    sl.registerLazySingleton<InviteDatasource>(
        () => InviteDatasourceImpl(dio: dio));
  }
}
