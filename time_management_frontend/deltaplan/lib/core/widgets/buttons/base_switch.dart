import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class BaseSwitch extends StatelessWidget {
  const BaseSwitch({Key? key, required this.value, required this.onToggle})
      : super(key: key);

  final bool value;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 34.pw,
      height: 20.ph,
      toggleSize: 16.ph,
      value: value,
      borderRadius: 80.0,
      padding: 2.pw,
      activeColor: CColors.blue,
      inactiveColor: CColors.darkGray,
      onToggle: onToggle,
    );
  }
}
