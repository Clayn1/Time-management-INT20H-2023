import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  ImagePreview({
    Key? key,
    this.imageSource,
    this.file,
    this.onDelete,
  }) : super(key: key);

  final String? imageSource;
  final File? file;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: onDelete != null ? 60.pw : 52.pw,
          width: onDelete != null ? 60.pw : 52.pw,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 52.pw,
              width: 52.pw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: CColors.darkGray,
                image: file != null
                    ? DecorationImage(
                        image: FileImage(file!),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: NetworkImage(imageSource ?? ''),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
        onDelete != null && file?.path != ''
            ? Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDelete,
                  icon: const Icon(Icons.cancel),
                  color: Colors.white,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
