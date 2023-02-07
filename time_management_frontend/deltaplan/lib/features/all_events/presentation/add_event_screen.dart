import 'dart:math';
import 'dart:typed_data';
import 'package:add_2_calendar/add_2_calendar.dart';

import 'package:deltaplan/core/helper/consts.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/paddings.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/date_time_formatter.dart';
import 'package:deltaplan/core/util/input_converter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/app_bars/base_app_bar.dart';
import 'package:deltaplan/core/widgets/buttons/base_button.dart';
import 'package:deltaplan/core/widgets/buttons/base_switch.dart';
import 'package:deltaplan/core/widgets/images/image_preview.dart';
import 'package:deltaplan/features/all_events/domain/entities/participant.dart';
import 'package:deltaplan/features/all_events/domain/entities/user_event.dart';
import 'package:deltaplan/features/all_events/presentation/cubit/add_event/add_event_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:deltaplan/features/all_events/presentation/components/filter_category.dart';
import 'package:deltaplan/features/invites/presentation/components/participant_tile.dart';
import 'package:deltaplan/features/sign_up/presentation/components/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:path_provider/path_provider.dart';

import 'components/add_image_button.dart';
import 'components/chooser_container.dart';
import 'components/event_text_field.dart';
import 'components/field_title.dart';
import 'cubit/all_events/all_events_cubit.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key, required this.isEdit, this.event})
      : super(key: key);

  final bool isEdit;
  final UserEvent? event;

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  AddEventCubit cubit = sl();

  late String name;
  late String description;
  late String category;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  late List<File> images = [];
  late List<String> participants = [];
  late bool remind = false;
  bool addToCalendar = false;

  @override
  void initState() {
    name = widget.event?.name ?? '';
    description = widget.event?.description ?? '';
    category = widget.event?.category ?? '';
    if (widget.event?.dateStart != null) {
      date = DateTimeFormatter.getDateTimeFromString(widget.event!.dateStart!);
    }
    if (widget.event?.dateStart != null) {
      startTime = DateTimeFormatter.getFormattedStringToTimeOfDay(
          widget.event!.dateStart!);
    }
    if (widget.event?.dateEnd != null) {
      endTime = DateTimeFormatter.getFormattedStringToTimeOfDay(
          widget.event!.dateEnd!);
    }
    getFilesFromLinks(widget.event?.documents ?? []);
    participants = getParticipantsEmails(widget.event?.participants ?? []);
    remind = widget.event?.reminder != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEventCubit, AddEventState>(
      bloc: cubit,
      listener: _blocListener,
      builder: (context, state) {
        return KeyboardDismissOnTap(
          child: Scaffold(
            backgroundColor: CColors.black,
            appBar: BaseAppBar(
              label: widget.isEdit ? 'Edit event' : 'Add event',
              isBackButton: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.pw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldTitle(
                          title: 'Event title',
                        ),
                        EventTextField(
                          initValue: name,
                          onChanged: (s) {
                            setState(() {
                              name = s;
                            });
                          },
                          hintText: 'Add event name',
                        ),
                        const FieldTitle(
                          title: 'Category',
                        ),
                      ],
                    ),
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
                              isChosen: category ==
                                  Consts.categories[index].toUpperCase(),
                              label: Consts.categories[index],
                              onTap: () {
                                setState(() {
                                  category =
                                      Consts.categories[index].toUpperCase();
                                });
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.pw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldTitle(
                          title: 'Date',
                        ),
                        ChooserContainer(
                          label: DateTimeFormatter.getFormattedWeekDayMonth(
                                  date) ??
                              'Choose date',
                          onTap: _selectDate,
                          icon: Icons.calendar_month_outlined,
                        ),
                        SizedBox(
                          height: 26.ph,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start time',
                                    style: montserrat.s14.lightGray.w500,
                                  ),
                                  SizedBox(
                                    height: 12.ph,
                                  ),
                                  ChooserContainer(
                                    label:
                                        startTime?.format(context) ?? 'Start',
                                    onTap: _selectTimeStart,
                                    icon: Icons.access_time_outlined,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20.pw,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End time',
                                    style: montserrat.s14.lightGray.w500,
                                  ),
                                  SizedBox(
                                    height: 12.ph,
                                  ),
                                  ChooserContainer(
                                    label: endTime?.format(context) ?? 'End',
                                    onTap: _selectTimeEnd,
                                    icon: Icons.access_time_outlined,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const FieldTitle(
                          title: 'Description',
                        ),
                        EventTextField(
                          initValue: description,
                          minLines: 3,
                          maxLines: 3,
                          onChanged: (s) {
                            setState(() {
                              description = s;
                            });
                          },
                          hintText: 'Add description',
                        ),
                        const FieldTitle(
                          title: 'Add images',
                        ),
                        Wrap(
                          spacing: 10.pw,
                          runSpacing: 10.pw,
                          children: [
                            AddImagesButton(
                              addImage: _addImage,
                            ),
                            ...List.generate(
                              images.length,
                              (index) => ImagePreview(
                                file: images[index],
                                onDelete: () {
                                  setState(() {
                                    images.remove(images[index]);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.ph,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Participants',
                                style: montserrat.s14.lightGray.w500,
                              ),
                            ),
                            SizedBox(
                              width: 16.pw,
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                _showAddParticipantDialogue();
                              },
                              icon: const Icon(
                                Icons.add,
                                color: CColors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.ph,
                        ),
                        participants.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  participants.length,
                                  (index) => Row(
                                    children: [
                                      Expanded(
                                        child: ParticipantTile(
                                          email: participants[index],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.pw,
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.all(2.pw),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            participants
                                                .remove(participants[index]);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: 24.ph,
                        ),
                        Row(
                          children: [
                            Text(
                              'Add to device calendar',
                              style: montserrat.s14.white.w500,
                            ),
                            SizedBox(
                              width: 16.pw,
                            ),
                            BaseSwitch(
                              value: addToCalendar,
                              onToggle: (v) {
                                setState(() {
                                  addToCalendar = v;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.ph,
                        ),
                        Row(
                          children: [
                            Text(
                              'Remind 1 hour before event',
                              style: montserrat.s14.white.w500,
                            ),
                            SizedBox(
                              width: 16.pw,
                            ),
                            BaseSwitch(
                              value: remind,
                              onToggle: (v) {
                                setState(() {
                                  remind = v;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 26.ph,
                        ),
                        BaseButton(
                          onTap: _onMainButtonTap,
                          label:
                              widget.isEdit ? 'Edit event' : 'Create new event',
                          padding: CPaddings.all14,
                          isActive: _isButtonActive(),
                          isLoading: state is AddEventLoading,
                        ),
                        SizedBox(
                          height: 30.ph,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isButtonActive() {
    return name.isNotEmpty &&
        category.isNotEmpty &&
        date != null &&
        startTime != null &&
        endTime != null;
  }

  void _selectDate() async {
    DateTime? selectedDate;
    selectedDate = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: Consts.firstDay,
      lastDate: Consts.lastDay,
      builder: (context, child) {
        return _darkTheme(child!);
      },
    );
    setState(() {
      date = selectedDate;
    });
  }

  void _selectTimeStart() async {
    TimeOfDay? selectedTime;
    selectedTime = await showTimePicker(
      initialTime: startTime ?? TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return _darkTheme(child!);
      },
    );
    setState(() {
      startTime = selectedTime;
    });
  }

  void _selectTimeEnd() async {
    TimeOfDay? selectedTime;
    selectedTime = await showTimePicker(
      initialTime: endTime ?? TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return _darkTheme(child!);
      },
    );
    setState(() {
      endTime = selectedTime;
    });
  }

  Theme _darkTheme(Widget child) {
    return Theme(
      data: Theme.of(context).copyWith(
        timePickerTheme: TimePickerThemeData(
          dayPeriodTextColor: Colors.white,
          hourMinuteColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? CColors.lightGray.withOpacity(0.1)
                : CColors.lightGray.withOpacity(0.1),
          ),
          hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected)
                ? CColors.white
                : CColors.white,
          ),
          dialBackgroundColor: CColors.lightGray.withOpacity(0.1),
        ),
        dialogBackgroundColor: CColors.darkGray,
        colorScheme: const ColorScheme.dark(
          surface: CColors.darkGray,
          onSurface: CColors.white,
          primary: CColors.blue,
          onPrimary: CColors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: CColors.blue,
          ),
        ),
      ),
      child: child,
    );
  }

  void _addImage(File file) {
    setState(() {
      images.add(file);
    });
  }

  _showAddParticipantDialogue() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String errorMessage = '';
          String currentParticipant = '';
          return StatefulBuilder(builder: (context, dialogState) {
            return AlertDialog(
              backgroundColor: CColors.black,
              title: Text(
                'Add a participant to event',
                style: montserrat.s18.white.w500,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthTextField(
                    onChanged: (s) {
                      dialogState(() {
                        currentParticipant = s;
                      });
                    },
                    hintText: 'Enter email',
                    hintSize: 14,
                  ),
                  errorMessage.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 8.ph),
                          child: Text(
                            errorMessage,
                            style: montserrat.s12.w400.copyWith(
                              color: Colors.red.shade400,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: montserrat.s14.blue.w400,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (InputChecker.checkEmail(currentParticipant) &&
                        !participants.contains(currentParticipant)) {
                      setState(() {
                        participants.add(currentParticipant);
                      });
                      Navigator.pop(context);
                    } else {
                      dialogState(() {
                        errorMessage = 'Invalid email';
                      });
                    }
                  },
                  child: Text(
                    'Add',
                    style: montserrat.s14.blue.w400,
                  ),
                ),
              ],
            );
          });
        });
  }

  Future getFilesFromLinks(List<String> links) async {
    for (var link in links) {
      setState(() {
        images.add(File(''));
      });
    }
    List<File> files = [];
    for (var link in links) {
      var rng = Random();
      files.add(await _processLink(link, rng));
    }
    setState(() {
      images.removeWhere((element) => element.path == '');
      images.addAll(files);
    });
  }

  Future<File> _processLink(String link, var rng) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath${rng.nextInt(100)}.png');
    http.Response response = await http.get(Uri.parse(link));
    return await file.writeAsBytes(response.bodyBytes);
  }

  void addToDeviceCalender() {
    final Event event = Event(
      title: name,
      description: description,
      startDate: DateTimeFormatter.getDateTime(date!, startTime!),
      endDate: DateTimeFormatter.getDateTime(date!, endTime!),
      iosParams: remind
          ? const IOSParams(
              reminder: Duration(hours: 1),
            )
          : const IOSParams(),
      androidParams: participants.isNotEmpty
          ? AndroidParams(
              emailInvites: participants,
            )
          : const AndroidParams(),
    );
    Add2Calendar.addEvent2Cal(event);
  }

  List<String> getParticipantsEmails(List<Participant> participantObjs) {
    List<String> emails = [];
    for (var element in participantObjs) {
      emails.add(element.user?.email ?? '');
    }
    return emails;
  }

  _blocListener(BuildContext context, AddEventState state) {
    if (state is AddEventSuccess) {
      Navigator.pop(context);
      sl<AllEventsCubit>().getEvents();
      if (addToCalendar) {
        addToDeviceCalender();
      }
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

  _onMainButtonTap() {
    UserEvent event = UserEvent(
      name: name,
      description: description,
      category: category,
      //documents: images,
      reminder: remind ? '1H' : null,
      dateStart: DateTimeFormatter.getStringFromDateTime(date!, startTime!),
      dateEnd: DateTimeFormatter.getStringFromDateTime(date!, endTime!),
    );
    if (widget.isEdit) {
      cubit.editEvent(widget.event?.id ?? -1, event, participants, images);
    } else {
      cubit.addEvent(event, participants, images);
    }
  }
}
