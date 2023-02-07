import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

class ChooserContainer extends StatelessWidget {
  const ChooserContainer({
    Key? key,
    required this.label,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final Function() onTap;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: CBorderRadius.all16,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 11.ph),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: CColors.lightGray.withOpacity(0.3),
          ),
          borderRadius: CBorderRadius.all16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: CColors.lightGray,
              size: 22,
            ),
            SizedBox(
              width: 12.pw,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Text(
                label,
                style: montserrat.w500.s16.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
