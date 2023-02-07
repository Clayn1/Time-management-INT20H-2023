import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/app_bars/base_app_bar.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, this.withoutBackButton = false})
      : super(key: key);

  final bool withoutBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.black,
      appBar: BaseAppBar(
        label: '',
        isBackButton: !withoutBackButton,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 100.ph),
          child: const CircularProgressIndicator(
            color: CColors.blue,
          ),
        ),
      ),
    );
  }
}
