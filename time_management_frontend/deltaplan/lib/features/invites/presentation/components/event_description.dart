import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

class EventDescription extends StatelessWidget {
  const EventDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return description.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(top: 12.ph),
            padding: EdgeInsets.symmetric(horizontal: 10.pw, vertical: 8.ph),
            decoration: const BoxDecoration(
              color: CColors.darkGray,
              borderRadius: CBorderRadius.all8,
            ),
            child: Text(
              description,
              style: montserrat.s14.white.w400,
            ),
          )
        : const SizedBox();
  }
}
