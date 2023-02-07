import 'package:deltaplan/core/helper/images.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, this.size = 50, this.padding}) : super(key: key);

  final double size;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: CColors.white,
      child: Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Image.asset(PngIcons.personNeutral),
      ),
    );
  }
}
