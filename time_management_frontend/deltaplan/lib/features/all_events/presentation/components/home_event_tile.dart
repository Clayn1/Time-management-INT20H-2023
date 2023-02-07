import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/date_time_formatter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/presentation/event_details_screen.dart';
import 'package:flutter/material.dart';

class HomeEventTile extends StatelessWidget {
  const HomeEventTile({Key? key, required this.event}) : super(key: key);

  final UserEvent event;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CColors.darkGray,
          border: Border(
            left: BorderSide(
                width: 4,
                color: CColors.getCategoryColor(event.category ?? '')),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
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
              padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 12.ph),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        CColors.getCategoryColor(event.category ?? ''),
                    child: const Icon(
                      Icons.list_alt_rounded,
                      color: CColors.darkGray,
                    ),
                  ),
                  SizedBox(
                    width: 16.pw,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name ?? 'Event',
                          style: montserrat.white.s14.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10.ph,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: CColors.lightGray,
                            ),
                            SizedBox(
                              width: 4.pw,
                            ),
                            Text(
                              '${DateTimeFormatter.getFormattedTime(event.dateStart ?? '', context)} - ${DateTimeFormatter.getFormattedTime(event.dateEnd ?? '', context)}',
                              style: montserrat.lightGray.s12.w500,
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
                    size: 20,
                    color: CColors.lightGray,
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
