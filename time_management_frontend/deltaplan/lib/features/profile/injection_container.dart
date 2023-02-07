import 'package:deltaplan/features/profile/data/datasourse/user_datasource.dart';
import 'package:deltaplan/features/profile/data/repositories/user_repository_impl.dart';
import 'package:deltaplan/features/profile/domain/repositories/user_repository.dart';
import 'package:deltaplan/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:deltaplan/features/sign_up/data/datasource/token_local_datasource.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/sign_in_repository.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/token_local_repository.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:dio/dio.dart';

mixin ProfileInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits
    sl.registerFactory<UserCubit>(() => UserCubit(repository: sl()));

    // repositories
    sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(datasource: sl()));

    // data sources
    sl.registerLazySingleton<UserDatasource>(
        () => UserDatasourceImpl(dio: dio));
  }
}
