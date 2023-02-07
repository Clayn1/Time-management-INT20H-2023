import 'package:bot_toast/bot_toast.dart';
import 'package:deltaplan/core/widgets/loading/loading_screen.dart';
import 'package:deltaplan/features/bottom_nav_bar/presentation/bottom_nav_bar_parent_screen.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/login_screen.dart';
import 'package:deltaplan/features/sign_up/presentation/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io';

import 'app_config.dart';
import 'core/helper/notification.dart';
import 'features/sign_up/data/datasource/token_local_datasource.dart';
import 'features/sign_up/data/repositories/token_local_repository_impl.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await InjectionContainer().init();

  sl<AppConfig>();
  runApp(
    ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (Platform.isAndroid) {
      FlutterAppBadger.removeBadge();
    }
    _startPushNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      home: MainNavigation(),
    );
  }

  void _startPushNotifications() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
  }
}

class MainNavigation extends StatefulWidget {
  MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late AuthCubit cubit;

  @override
  void initState() {
    cubit = sl();
    checkIfUserAuthorized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        bloc: cubit,
        listener: (context, state) {},
        builder: (context, state) {
          return state is AuthInitial
              ? const LoadingScreen(
                  withoutBackButton: true,
                )
              : state is AuthSuccess
                  ? BottomNavBarParentScreen(authCubit: cubit)
                  : LoginScreen(authCubit: cubit);
        });
  }

  Future checkIfUserAuthorized() async {
    await sl<TokenLocalDatasource>().init();
    cubit.checkIfUserAuthorized();
  }
}
