import 'dart:collection';

import 'package:deltaplan/core/helper/consts.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/date_time_formatter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/loading/loading_screen.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/all_events/all_events_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import 'components/event_tile.dart';
import 'components/marked_up_events.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late AllEventsCubit _cubit;

  @override
  void initState() {
    _cubit = sl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllEventsCubit, AllEventsState>(
      bloc: _cubit,
      builder: (context, state) {
        return state is AllEventsMain
            ? Scaffold(
                backgroundColor: CColors.black,
                body: Padding(
                  padding: EdgeInsets.fromLTRB(20.pw, 60.ph, 20.pw, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TableCalendar(
                        firstDay: Consts.firstDay,
                        lastDay: Consts.lastDay,
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        headerStyle: _getHeaderStyle(),
                        daysOfWeekStyle: _getDaysOfWeekStyle(),
                        calendarStyle: _getCalendarStyle(),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                          CalendarFormat.week: 'Week'
                        },
                        startingDayOfWeek: StartingDayOfWeek.monday,
                      ),
                      SizedBox(
                        height: 16.ph,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                                child: _getEventsView(_cubit.getEventsForDay(
                                    state.eventGroups, _selectedDay)),
                              ),
                              SizedBox(
                                height: 120.ph,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const LoadingScreen(
                withoutBackButton: true,
              );
      },
    );
  }

  HeaderStyle _getHeaderStyle() {
    if (_calendarFormat == CalendarFormat.month) {
      return HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: montserrat.white.w700.s24,
        leftChevronPadding: EdgeInsets.only(right: 16.pw),
        rightChevronPadding: EdgeInsets.only(left: 16.pw),
        leftChevronIcon: const Icon(
          Icons.arrow_back_ios_new_sharp,
          color: CColors.white,
          size: 20,
        ),
        rightChevronIcon: const Icon(
          Icons.arrow_forward_ios_sharp,
          color: CColors.white,
          size: 20,
        ),
        leftChevronMargin: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
        headerMargin: EdgeInsets.zero,
        headerPadding: EdgeInsets.only(bottom: 20.ph),
      );
    } else {
      return HeaderStyle(
        titleCentered: false,
        formatButtonVisible: false,
        titleTextStyle: montserrat.white.w700.s18,
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerPadding: EdgeInsets.only(bottom: 20.ph, left: 8),
      );
    }
  }

  DaysOfWeekStyle _getDaysOfWeekStyle() {
    return DaysOfWeekStyle(
      weekdayStyle: montserrat.white.w500.s14,
      weekendStyle: montserrat.white.w500.s14,
    );
  }

  CalendarStyle _getCalendarStyle() {
    return CalendarStyle(
      todayDecoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      selectedDecoration: const BoxDecoration(
        color: CColors.blue,
        shape: BoxShape.circle,
      ),
      defaultTextStyle: montserrat.white.w500.s14,
      weekendTextStyle: montserrat.white.w500.s14,
      outsideTextStyle: montserrat.lightGray.w500.s14,
    );
  }

  Widget _getEventsView(List<UserEvent> events) {
    if (_calendarFormat == CalendarFormat.month) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateTimeFormatter.getFormattedMonthDay(_selectedDay),
            style: montserrat.white.w700.s18,
          ),
          SizedBox(
            height: 16.ph,
          ),
          ...List.generate(
            events.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.ph),
              child: EventTile(event: events[index]),
            ),
          ),
        ],
      );
    } else {
      return MarkedUpEvents(events: _cubit.getGroupedByTimeEvents(events));
    }
  }
}
