import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/paddings.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/app_bars/base_app_bar.dart';
import 'package:deltaplan/core/widgets/buttons/base_button.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/presentation/add_event_screen.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/add_event/add_event_cubit.dart';
import 'package:deltaplan/features/invites/presentation/components/event_category.dart';
import 'package:deltaplan/features/invites/presentation/components/event_description.dart';
import 'package:deltaplan/features/invites/presentation/components/images_tile.dart';
import 'package:deltaplan/features/invites/presentation/components/invite_tile.dart';
import 'package:deltaplan/features/invites/presentation/components/participants_tile.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/all_events/all_events_cubit.dart';

class EventDetailsScreen extends StatelessWidget {
  EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  final UserEvent event;

  AddEventCubit cubit = sl();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEventCubit, AddEventState>(
      bloc: cubit,
      listener: _blocListener,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CColors.black,
          appBar: BaseAppBar(
            label: 'Event details',
            isBackButton: true,
            rightWidget: event.category != "GOOGLE"
                ? IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: CColors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddEventScreen(isEdit: true, event: event),
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).padding.top + kToolbarHeight),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.pw, 20.ph, 20.pw, 0.ph),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name ?? 'Event',
                          style: montserrat.s18.white.w700,
                        ),
                        SizedBox(
                          height: 12.ph,
                        ),
                        EventCategory(
                          category: event.category ?? '',
                        ),
                        SizedBox(
                          height: 12.ph,
                        ),
                        DateTimeWidget(
                          dateStart: event.dateStart ?? '',
                          dateEnd: event.dateEnd ?? '',
                        ),
                        EventDescription(
                          description: event.description ?? '',
                        ),
                        ParticipantsTile(
                          participants: event.participants ?? [],
                        ),
                        ImagesTile(
                          images: event.documents ?? [],
                        ),
                        SizedBox(
                          height: 120.ph,
                        ),
                      ],
                    ),
                  ),
                ),
                event.category != "GOOGLE"
                    ? Positioned(
                        bottom: 50.ph,
                        right: 20.pw,
                        left: 20.pw,
                        child: BaseButton(
                          onTap: () {
                            cubit.deleteEvent(event.id ?? -1);
                          },
                          label: 'Delete event',
                          color: Colors.red.shade300,
                          padding: CPaddings.all14,
                          isLoading: state is AddEventLoading,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  _blocListener(BuildContext context, AddEventState state) {
    if (state is AddEventSuccess) {
      Navigator.pop(context);
      sl<AllEventsCubit>().getEvents();
    }
    if (state is AddEventFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unexpected error occurred',
            style: montserrat.s14.white.w500,
          ),
        ),
      );
    }
  }
}
