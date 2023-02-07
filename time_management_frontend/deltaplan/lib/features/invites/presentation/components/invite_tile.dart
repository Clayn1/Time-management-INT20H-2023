import 'package:animated_widgets/animated_widgets.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/date_time_formatter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/buttons/base_button.dart';
import 'package:deltaplan/features/invites/domain/entities/invite.dart';
import 'package:deltaplan/features/invites/presentation/cubit/invite_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';

import 'category_indicator.dart';

class InviteTile extends StatefulWidget {
  InviteTile({Key? key, required this.invite, required this.index})
      : super(key: key);

  final Invite invite;
  final int index;

  @override
  State<InviteTile> createState() => _InviteTileState();
}

class _InviteTileState extends State<InviteTile> {
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return TranslationAnimatedWidget.tween(
        enabled: enabled,
        translationDisabled: const Offset(-2000, 0),
        translationEnabled: const Offset(0, 0),
        duration: const Duration(milliseconds: 250),
        child: OpacityAnimatedWidget.tween(
          enabled: enabled,
          opacityDisabled: 1,
          opacityEnabled: 1,
          duration: const Duration(milliseconds: 500),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 12.ph),
            decoration: BoxDecoration(
              color: CColors.darkGray,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.invite.email ?? '',
                        style: montserrat.s15.w700.white,
                      ),
                    ),
                    SizedBox(
                      width: 8.pw,
                    ),
                    // widget.isNew ? const NewTile() : const SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 6.ph,
                ),
                Text(
                  'invites you to join the event:',
                  style: montserrat.s12.w500.lightGray,
                ),
                SizedBox(
                  height: 6.ph,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryIndicator(
                      category: widget.invite.category ?? '',
                    ),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                      child: Text(
                        "\"${widget.invite.eventName ?? 'Event'}\"",
                        style: montserrat.s14.w500.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.ph,
                ),
                DateTimeWidget(
                  dateEnd: widget.invite.dateStart ?? '',
                  dateStart: widget.invite.dateEnd ?? '',
                ),
                SizedBox(
                  height: 10.ph,
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        label: 'Accept'.toUpperCase(),
                        onTap: () {
                          sl<InviteCubit>().acceptInvite(
                              widget.invite.invitationId ?? -1, widget.index);
                          /*setState(() {
                            enabled = false;
                          });*/
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8.pw,
                    ),
                    Expanded(
                      child: BaseButton(
                        label: 'Decline'.toUpperCase(),
                        onTap: () {
                          sl<InviteCubit>().declineInvite(
                              widget.invite.invitationId ?? -1, widget.index);
                          /* setState(() {
                            enabled = false;
                          });*/
                        },
                        color: CColors.lightGray,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key,
    required this.dateEnd,
    required this.dateStart,
  });

  final String dateStart;
  final String dateEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time,
          size: 16,
          color: CColors.lightGray,
        ),
        SizedBox(
          width: 4.pw,
        ),
        Expanded(
          child: Text(
            "${DateTimeFormatter.getFormattedTimeWeekDate(dateStart)} - ${DateTimeFormatter.getFormattedTimeWeekDate(dateEnd)}",
            style: montserrat.s12.w500.lightGray,
          ),
        ),
      ],
    );
  }
}

class NewTile extends StatelessWidget {
  const NewTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.pw, vertical: 2.ph),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CColors.pastelBlue),
      ),
      child: Center(
        child: Text(
          '${'New'.toUpperCase()}!',
          style: montserrat.s8.w400.pastelBlue,
        ),
      ),
    );
  }
}
