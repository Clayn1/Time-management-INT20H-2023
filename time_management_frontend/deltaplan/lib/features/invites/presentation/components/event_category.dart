import 'package:deltaplan/core/helper/extensions.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';

import 'category_indicator.dart';

class EventCategory extends StatelessWidget {
  const EventCategory({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CategoryIndicator(
          category: category,
        ),
        SizedBox(
          width: 8.pw,
        ),
        Text(
          category.capitalize,
          style: montserrat.s14.w500.copyWith(
            color: CColors.getCategoryColor(category),
          ),
        ),
      ],
    );
  }
}
