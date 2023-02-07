import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

class CategoryIndicator extends StatelessWidget {
  const CategoryIndicator({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.pw,
      width: 8.pw,
      decoration: BoxDecoration(
        color: CColors.getCategoryColor(category),
        shape: BoxShape.circle,
      ),
    );
  }
}
