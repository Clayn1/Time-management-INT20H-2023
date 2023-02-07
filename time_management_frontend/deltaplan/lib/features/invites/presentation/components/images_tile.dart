import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/images/image_preview.dart';
import 'package:deltaplan/core/widgets/images/image_view.dart';
import 'package:deltaplan/features/invites/presentation/components/participant_tile.dart';
import 'package:flutter/material.dart';

class ImagesTile extends StatelessWidget {
  ImagesTile({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return images.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 12.ph),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Images:',
                  style: montserrat.s15.white.w700,
                ),
                SizedBox(
                  height: 12.ph,
                ),
                Wrap(
                  spacing: 12.pw,
                  runSpacing: 12.pw,
                  children: List.generate(
                    images.length,
                    (index) => GestureDetector(
                      onTap: () {
                        showBottomSheet(
                          context: context,
                          builder: (_) =>
                              ImageView(images: images, imageIndex: index),
                          backgroundColor:
                              const Color(0xFF111316).withOpacity(0.84),
                        );
                      },
                      child: ImagePreview(
                        imageSource: images[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
