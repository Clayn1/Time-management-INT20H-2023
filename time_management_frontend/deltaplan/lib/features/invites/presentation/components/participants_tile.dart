import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/features/all_events/domain/entities/participant.dart';
import 'package:deltaplan/features/invites/presentation/components/participant_tile.dart';
import 'package:flutter/material.dart';

class ParticipantsTile extends StatelessWidget {
  const ParticipantsTile({super.key, required this.participants});

  final List<Participant> participants;

  @override
  Widget build(BuildContext context) {
    return participants.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 12.ph),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Participants:',
                  style: montserrat.s15.white.w700,
                ),
                SizedBox(
                  height: 8.ph,
                ),
                ...List.generate(
                  participants.length,
                  (index) => ParticipantTile(
                    email: participants[index].user?.email ?? '',
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
