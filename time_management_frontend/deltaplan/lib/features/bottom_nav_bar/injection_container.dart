import 'package:deltaplan/features/bottom_nav_bar/presentation/cubit/bottom_nav_bar_cubit.dart';
import 'package:deltaplan/injection_container.dart';

mixin BottomNavBarInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    // cubits
    sl.registerLazySingleton<BottomNavBarCubit>(() => BottomNavBarCubit());

    // use cases

    // repositories

    // data sources
  }
}
