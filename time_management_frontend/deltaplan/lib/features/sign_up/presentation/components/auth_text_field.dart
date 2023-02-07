import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/text_fields/base_text_field.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.onChanged,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.hintSize = 16,
  });

  final String hintText;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final double hintSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.pw),
      decoration: const BoxDecoration(
        color: CColors.darkGray,
        borderRadius: CBorderRadius.all12,
      ),
      child: BaseTextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: montserrat.w500.s16.white,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: montserrat.w500.lightGray.copyWith(fontSize: hintSize),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        obscureText: obscureText,
        obscuringCharacter: '●',
      ),
    );
  }
}
