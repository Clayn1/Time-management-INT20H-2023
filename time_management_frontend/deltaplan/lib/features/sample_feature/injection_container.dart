import 'package:deltaplan/injection_container.dart';
import 'package:dio/dio.dart';

mixin SampleInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits

    // use cases

    // repositories

    // data sources
  }
}
