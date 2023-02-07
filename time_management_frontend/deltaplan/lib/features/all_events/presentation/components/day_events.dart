import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/date_time_formatter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/presentation/components/home_event_tile.dart';
import 'package:flutter/material.dart';

class DayEvents extends StatelessWidget {
  const DayEvents({Key? key, required this.events, required this.date})
      : super(key: key);

  final String date;
  final List<UserEvent> events;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateTimeFormatter.getFormattedStringToWeekDate(date),
          style: montserrat.s12.w500.lightGray,
        ),
        SizedBox(
          height: 12.ph,
        ),
        Column(
          children: List.generate(
            events.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 8.ph),
              child: HomeEventTile(
                event: events[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
