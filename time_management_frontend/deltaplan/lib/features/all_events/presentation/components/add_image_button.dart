import 'package:deltaplan/core/style/border_radiuses.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddImagesButton extends StatefulWidget {
  const AddImagesButton({Key? key, required this.addImage}) : super(key: key);

  final Function(File) addImage;

  @override
  State<AddImagesButton> createState() => _AddImagesButtonState();
}

class _AddImagesButtonState extends State<AddImagesButton> {
  bool imageLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.pw,
      width: 60.pw,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: InkWell(
          onTap: () {
            showImageSourceActionSheet(context);
          },
          borderRadius: CBorderRadius.all12,
          child: Ink(
            height: 52.pw,
            width: 52.pw,
            decoration: const BoxDecoration(
              color: CColors.darkGray,
              borderRadius: CBorderRadius.all12,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(right: 0.pw),
                child: const Icon(
                  Icons.attachment_sharp,
                  color: CColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void pickImage(ImageSource source) async {
    try {
      setState(() {
        imageLoading = true;
      });
      if (source == ImageSource.gallery) {
        final List<XFile> tempImages = await ImagePicker().pickMultiImage();
        for (var image in tempImages) {
          widget.addImage(File(image.path));
        }
      } else if (source == ImageSource.camera) {
        final XFile? tempImage = await ImagePicker().pickImage(source: source);
        if (tempImage == null) {
          setState(() {
            imageLoading = false;
          });
          return;
        }
        widget.addImage(File(tempImage.path));
      }
      setState(() {
        imageLoading = false;
      });
    } on PlatformException catch (e) {
      print('Error of picking image: $e');
    }
  }
}
