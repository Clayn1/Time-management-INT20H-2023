import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/text_fields/base_text_field.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.onChanged,
    required this.hintText,
  });

  final String hintText;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.pw),
      decoration: const BoxDecoration(
        color: CColors.darkGray,
        borderRadius: CBorderRadius.all12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: CColors.lightGray,
          ),
          SizedBox(
            width: 8.pw,
          ),
          Expanded(
            child: BaseTextField(
              onChanged: onChanged,
              style: montserrat.w500.s16.white,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: montserrat.w500.s16.lightGray,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
