import 'package:deltaplan/core/helper/widget_ext.dart';
import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

class FilterCategory extends StatelessWidget {
  const FilterCategory({
    super.key,
    required this.isChosen,
    required this.label,
    required this.onTap,
  });

  final bool isChosen;
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.pw, vertical: 10.ph),
        decoration: BoxDecoration(
          borderRadius: CBorderRadius.all12,
          color: isChosen ? CColors.blue : CColors.darkGray,
        ),
        child: Text(
          label,
          style: montserrat.s14.w500.white,
        ),
      ),
    ).noSplash().withHapticFeedback();
  }
}
