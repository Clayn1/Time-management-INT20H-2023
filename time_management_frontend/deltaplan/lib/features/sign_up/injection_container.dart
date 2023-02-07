import 'package:deltaplan/core/interceptors/token_interceptor.dart';
import 'package:deltaplan/features/sign_up/data/datasource/token_local_datasource.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/sign_in_repository.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/token_local_repository.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:dio/dio.dart';

import 'data/datasource/sign_in_datasourse.dart';
import 'data/datasource/sign_up_datasourse.dart';
import 'data/repositories/sign_in_repository_impl.dart';
import 'data/repositories/sign_up_repository_impl.dart';
import 'data/repositories/token_local_repository_impl.dart';
import 'domain/repositories/sign_up_repository.dart';

mixin AuthInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits
    sl.registerFactory<SignInCubit>(() => SignInCubit(repository: sl()));
    sl.registerFactory<SignUpCubit>(() => SignUpCubit(repository: sl()));
    sl.registerFactory<AuthCubit>(() => AuthCubit(repository: sl()));

    // repositories
    sl.registerLazySingleton<SignInRepository>(
        () => SignInRepositoryImpl(datasource: sl()));
    sl.registerLazySingleton<SignUpRepository>(
        () => SignUpRepositoryImpl(datasource: sl()));
    sl.registerLazySingleton<TokenLocalRepository>(
        () => TokenLocalRepositoryImpl(tokenLocalDatasource: sl()));

    // data sources
    sl.registerLazySingleton<SignInDatasource>(
        () => SignInDatasourceImpl(dio: dio));
    // data sources
    sl.registerLazySingleton<SignUpDatasource>(
        () => SignUpDatasourceImpl(dio: dio));
    sl.registerLazySingleton<TokenLocalDatasource>(
        () => TokenLocalDatasourceImpl());

    dio.interceptors.add(TokenInterceptor(tokenLocalRepository: sl()));
  }
}
