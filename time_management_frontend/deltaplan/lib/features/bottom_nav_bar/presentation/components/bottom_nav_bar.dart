import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/features/bottom_nav_bar/presentation/cubit/bottom_nav_bar_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        bloc: sl(),
        builder: (context, state) {
          return AnimatedBottomNavigationBar.builder(
            backgroundColor: CColors.bottomNavBar,
            itemCount: icons.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? CColors.blue : CColors.lightGray;
              return Icon(
                icons[index],
                size: 24,
                color: color,
              );
            },
            activeIndex: state.currentIndex,
            gapLocation: GapLocation.center,
            splashColor: CColors.blue.withOpacity(0.8),
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) {
              sl<BottomNavBarCubit>().changeIndex(index);
            },
            //other params
          );
        });
  }

  List<IconData> icons = const [
    Icons.home_filled,
    Icons.calendar_month_rounded,
    Icons.notifications,
    Icons.person,
  ];
}
