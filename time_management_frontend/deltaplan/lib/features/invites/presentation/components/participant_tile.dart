import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.ph),
      padding: EdgeInsets.symmetric(horizontal: 4.pw, vertical: 2.ph),
      child: Text(
        ' - $email',
        style: montserrat.s14.white.w400.italic,
      ),
    );
  }
}
