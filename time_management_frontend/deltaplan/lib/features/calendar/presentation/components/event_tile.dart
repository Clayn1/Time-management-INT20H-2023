import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/date_time_formatter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/presentation/event_details_screen.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  const EventTile({Key? key, required this.event}) : super(key: key);

  final UserEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.ph,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CColors.getCategoryColor(event.category ?? ''),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailsScreen(
                  event: event,
                ),
              ),
            );
          },
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 16.pw),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          event.name ?? '',
                          style: montserrat.black.s16.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4.ph,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: CColors.darkGray,
                            ),
                            SizedBox(
                              width: 4.pw,
                            ),
                            Text(
                              '${DateTimeFormatter.getFormattedTime(event.dateStart ?? '', context)} - ${DateTimeFormatter.getFormattedTime(event.dateEnd ?? '', context)}',
                              style: montserrat.darkGray.s14.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8.pw,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                    color: CColors.darkGray,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
