import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/features/all_events/presentation/add_event_screen.dart';
import 'package:deltaplan/features/all_events/presentation/home_screen.dart';
import 'package:deltaplan/features/bottom_nav_bar/presentation/cubit/bottom_nav_bar_cubit.dart';
import 'package:deltaplan/features/calendar/presentation/calendar_screen.dart';
import 'package:deltaplan/features/invites/presentation/invite_screen.dart';
import 'package:deltaplan/features/profile/presentation/profile_screen.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/bottom_nav_bar.dart';

class BottomNavBarParentScreen extends StatefulWidget {
  const BottomNavBarParentScreen({Key? key, required this.authCubit})
      : super(key: key);

  final AuthCubit authCubit;

  @override
  State<BottomNavBarParentScreen> createState() =>
      _BottomNavBarParentScreenState();
}

class _BottomNavBarParentScreenState extends State<BottomNavBarParentScreen> {
  late final List<Widget> pages = [
    const HomeScreen(),
    CalendarScreen(),
    const InviteScreen(),
    ProfileScreen(authCubit: widget.authCubit),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      bloc: sl(),
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          backgroundColor: CColors.black,
          floatingActionButton: FloatingActionButton(
            elevation: 8,
            backgroundColor: CColors.blue,
            child: const Icon(
              Icons.add,
              color: CColors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEventScreen(isEdit: false),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavBar(),
          body: pages[state.currentIndex],
        );
      },
    );
  }
}
