import 'package:deltaplan/core/helper/consts.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/all_events/all_events_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_tile.dart';

class MarkedUpEvents extends StatelessWidget {
  MarkedUpEvents({Key? key, required this.events}) : super(key: key);

  final Map<String, List<UserEvent>> events;

  AllEventsCubit cubit = sl();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllEventsCubit, AllEventsState>(
      bloc: cubit,
      builder: (context, state) {
        return Column(
          children: List.generate(Consts.times.length, (index) {
            String formattedTime = Consts.times[index].substring(0, 2);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeRow(
                  time: Consts.times[index],
                ),
                cubit.isTimeMatch(formattedTime, events.keys)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            cubit
                                .getMatchElements(formattedTime, events)
                                .length, (evIndex) {
                          UserEvent currentEvent = cubit.getMatchElements(
                              formattedTime, events)[evIndex];
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 50.pw, top: evIndex != 0 ? 12.ph : 0),
                            child: EventTile(
                              event: currentEvent,
                            ),
                          );
                        }),
                      )
                    : SizedBox(
                        height: 70.ph,
                      ),
              ],
            );
          }),
        );
      },
    );
  }
}

class TimeRow extends StatelessWidget {
  const TimeRow({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          time,
          style: montserrat.w500.s14.copyWith(
            color: CColors.lightGray.withOpacity(0.6),
          ),
        ),
        SizedBox(
          width: 8.pw,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: CColors.lightGray.withOpacity(0.3),
            height: 1,
          ),
        ),
      ],
    );
  }
}
