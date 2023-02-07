import 'dart:ui' as ui;
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageView extends StatefulWidget {
  ImageView({
    Key? key,
    required this.images,
    required this.imageIndex,
  }) : super(key: key);

  final List<String> images;
  final int imageIndex;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final CarouselController controller = CarouselController();

  late var activePage = widget.imageIndex;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.transparent,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: CColors.lightGray,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.ph,
                    ),
                    CarouselSlider(
                      items: List.generate(
                        widget.images.length,
                        (index) {
                          bool fitImage =
                              doFitImage(widget.images[index], height, width);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: height * 0.63,
                                width: width - 16,
                                decoration:
                                    const BoxDecoration(color: Colors.black),
                                child: Image.network(
                                  widget.images[index],
                                  fit: fitImage ? BoxFit.fill : BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      options: CarouselOptions(
                          initialPage: widget.imageIndex,
                          enlargeCenterPage: false,
                          height: height * 0.63,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, _) {
                            setState(() {
                              activePage = index;
                            });
                          }),
                      carouselController: controller,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AnimatedSmoothIndicator(
                      activeIndex: activePage,
                      count: widget.images.length,
                      effect: const ScrollingDotsEffect(
                        dotWidth: 6,
                        dotHeight: 6,
                        activeDotScale: 1.3,
                        activeDotColor: CColors.blue,
                        dotColor: CColors.darkGray,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool doFitImage(String path, double height, double width) {
    Image image = Image.network(path);
    bool fitImage = false;
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      fitImage = (info.image.height / info.image.width) >=
              ((height * 0.63 / (width - 16)) - 0.1) &&
          (info.image.height / info.image.width) <=
              ((height * 0.63 / (width - 16)) + 0.1);
    }));
    return fitImage;
  }
}
