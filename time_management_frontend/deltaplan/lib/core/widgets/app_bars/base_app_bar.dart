import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/paddings.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaseAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget? leftWidget;
  final Widget? rightWidget;
  final String? label;
  final Color? backgroundColor;
  final bool isBackButton;

  const BaseAppBar({
    Key? key,
    this.leftWidget,
    this.rightWidget,
    this.label,
    this.backgroundColor,
    this.isBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 50,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: isBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: CColors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Padding(
                padding: CPaddings.horizontal16,
                child: leftWidget,
              ),
      ),
      actions: [
        Center(
          child: rightWidget,
        )
      ],
      title: label != null
          ? Text(
              label!,
              style: montserrat.s26.w700.white,
            )
          : const SizedBox(),
      backgroundColor: backgroundColor ?? CColors.black,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size(100.w, 50.ph);
}
