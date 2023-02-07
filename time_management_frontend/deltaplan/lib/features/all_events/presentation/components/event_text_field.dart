import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/text_fields/base_text_field.dart';
import 'package:flutter/material.dart';

class EventTextField extends StatelessWidget {
  const EventTextField({
    Key? key,
    required this.onChanged,
    required this.hintText,
    required this.initValue,
    this.maxLines,
    this.minLines,
  }) : super(key: key);

  final Function(String) onChanged;
  final String hintText;
  final int? minLines;
  final int? maxLines;
  final String initValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      style: montserrat.w500.s16.white,
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.pw, vertical: 12.ph),
        hintText: hintText,
        hintStyle: montserrat.w500.s16.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: CColors.lightGray.withOpacity(0.3),
          ),
          borderRadius: CBorderRadius.all16,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: CColors.white.withOpacity(0.3),
          ),
          borderRadius: CBorderRadius.all16,
        ),
      ),
    );
  }
}
