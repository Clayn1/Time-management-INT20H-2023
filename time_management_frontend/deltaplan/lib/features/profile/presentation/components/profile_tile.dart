import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile(
      {Key? key,
      required this.onTap,
      required this.label,
      required this.iconColor,
      this.bgColor,
      required this.icon})
      : super(key: key);

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color? bgColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor ?? CColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            SizedBox(
              width: 10.pw,
            ),
            Text(
              label,
              style: montserrat.s15.w500.white,
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: CColors.lightGray,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
