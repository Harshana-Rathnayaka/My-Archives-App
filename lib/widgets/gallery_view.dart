import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../constants/images.dart';

class GalleryView extends StatefulWidget {
  static var tag = "/GalleryView";

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late PageController pageController;
  late List images;
  late int index;

  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)!.settings.arguments as Map;

    if (isFirstTime) {
      pageController = PageController(initialPage: args['selectedIndex']);
      images = args['images'];
      index = args['selectedIndex'];
      isFirstTime = false;
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            itemCount: images.length,
            pageController: pageController,
            onPageChanged: (index) => setState(() => this.index = index),
            loadingBuilder: (context, ImageChunkEvent? event) {
              double value = event == null ? 0 : event.cumulativeBytesLoaded / double.parse(event.expectedTotalBytes.toString());
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: Column(
                      children: [
                        Center(child: CircularProgressIndicator(value: value)),
                        SizedBox(height: 8),
                        Text('loading... ${(value * 100).toStringAsFixed(0)}%', style: TextStyle(fontFamily: fontMedium)),
                      ],
                    ),
                  ),
                ],
              );
            },
            builder: (context, index) {
              final image = images[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(image),
                heroAttributes: PhotoViewHeroAttributes(tag: image),
                errorBuilder: (context, object, stacktrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(brokenImage), fit: BoxFit.cover)),
                      ),
                      Text('Something went wrong!', style: TextStyle(fontFamily: fontMedium)),
                    ],
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Image ${index + 1}/${images.length}', style: TextStyle(fontFamily: fontMedium, color: colorWhite)),
          )
        ],
      ),
    );
  }
}
