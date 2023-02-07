import 'package:deltaplan/core/helper/consts.dart';
import 'package:deltaplan/core/helper/images.dart';
import 'package:deltaplan/core/widgets/loading/loading_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/greeting_tool.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/images/user_avatar.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/all_events/all_events_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/day_events.dart';
import 'components/filter_category.dart';
import 'components/search_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AllEventsCubit cubit = sl();

  @override
  void initState() {
    cubit.getEvents();
    /* SchedulerBinding.instance
        .addPostFrameCallback((_) => _showGoogleCalendarAlert(context));*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllEventsCubit, AllEventsState>(
      bloc: cubit,
      builder: (context, state) {
        return KeyboardDismissOnTap(
          child: state is AllEventsMain
              ? Scaffold(
                  backgroundColor: CColors.black,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60.ph,
                      ),
                      const HomeHeader(),
                      SizedBox(
                        height: 24.ph,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.pw),
                        child: SearchTextField(
                          hintText: 'Search event',
                          onChanged: (s) {
                            cubit.addSearchQuery(s);
                            cubit.getEvents();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 28.ph,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.pw),
                        child: Text(
                          'All tasks for categories',
                          style: montserrat.s20.w700.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20.ph,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20.pw,
                            ),
                            ...List.generate(
                              Consts.categories.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 16.pw),
                                child: FilterCategory(
                                  isChosen: state.filterCategories.contains(
                                      Consts.categories[index].toUpperCase()),
                                  label: Consts.categories[index],
                                  onTap: () {
                                    cubit.addFilterCategory(
                                        Consts.categories[index].toUpperCase());
                                    cubit.getEvents();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.pw,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.ph,
                      ),
                      state.eventGroups.isNotEmpty
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.pw),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...List.generate(
                                            state.eventGroups.length, (index) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10.ph),
                                            child: DayEvents(
                                              date: state.eventGroups.keys
                                                  .elementAt(index),
                                              events: state.eventGroups.values
                                                  .elementAt(index),
                                            ),
                                          );
                                        }),
                                        SizedBox(
                                          height: 120.ph,
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          : const NothingFound(),
                    ],
                  ))
              : const LoadingScreen(
                  withoutBackButton: true,
                ),
        );
      },
    );
  }

  _showGoogleCalendarAlert(BuildContext initContext) {
    showDialog(
      context: initContext,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CColors.black,
        title: Text(
          'Add events from Google Calendar',
          style: montserrat.s18.white.w500,
        ),
        content: Text(
          'Do you want to add in DeltaPlan your Google Calendar events?',
          style: montserrat.s14.white.w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'No',
              style: montserrat.s14.blue.w400,
            ),
          ),
          TextButton(
            onPressed: () {
              cubit.signUpGoogleAndGetEvents();
              Navigator.pop(context, true);
            },
            child: Text(
              'Yes',
              style: montserrat.s14.blue.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class NothingFound extends StatelessWidget {
  const NothingFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 80.ph,
          ),
          Text(
            'You have no suitable events',
            style: montserrat.s18.w500.white,
          ),
          SizedBox(
            height: 30.ph,
          ),
          Image.asset(
            PngIcons.nullim,
            color: CColors.white,
            height: 60.pw,
            width: 60.pw,
          )
        ],
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.pw),
      child: Row(
        children: [
          const UserAvatar(
            size: 28,
            padding: EdgeInsets.fromLTRB(8, 4, 4, 4),
          ),
          SizedBox(
            width: 16.pw,
          ),
          Text(
            GreetingTool.getGreeting(),
            style: montserrat.s18.w500.white,
          ),
        ],
      ),
    );
  }
}
