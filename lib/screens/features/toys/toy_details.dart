import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../constants/images.dart';
import '../../../models/toy.dart';
import '../../../utils/helper_methods.dart';

class ToyDetails extends StatefulWidget {
  static var tag = "/ToyDetails";

  const ToyDetails({Key? key}) : super(key: key);

  @override
  State<ToyDetails> createState() => _ToyDetailsState();
}

class _ToyDetailsState extends State<ToyDetails> {
  late Size size;

  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    Toy toy = ModalRoute.of(context)!.settings.arguments as Toy;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => viewImage(toy.images, selectedImage),
                child: SizedBox(
                  width: size.width,
                  height: size.width / 1.5,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Hero(
                      tag: toy.images[selectedImage],
                      child: CachedNetworkImage(
                        imageUrl: toy.images[selectedImage],
                        placeholder: (context, url) => new Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => new Icon(Icons.error, size: 26, color: colorRed),
                        imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover))),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 50,
                  left: 30,
                  child: GestureDetector(
                      onTap: () {
                        finish(context);
                      },
                      child: Icon(Icons.arrow_back_ios))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [...List.generate(toy.images.length, (index) => imagePreview(toy.images, index))],
          ),
        ],
      ),
    );
  }

  GestureDetector imagePreview(List images, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedImage = index),
      child: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(right: 15, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selectedImage == index ? Theme.of(context).colorScheme.secondary : Colors.transparent),
        ),
        child: CachedNetworkImage(
          imageUrl: images[index],
          placeholder: (context, url) => new Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => new Icon(Icons.error, color: colorRed),
          imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          )),
        ),
      ),
    );
  }

  void viewImage(List images, selectedIndex) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Gallery(images: images, index: selectedIndex)));
}

class Gallery extends StatefulWidget {
  final List images;
  final int index;
  final PageController pageController;

  Gallery({required this.images, this.index = 0}) : pageController = PageController(initialPage: index);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.images.length,
            pageController: widget.pageController,
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
              final image = widget.images[index];
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
            child: Text('Image ${index + 1}/${widget.images.length}', style: TextStyle(fontFamily: fontMedium, color: colorWhite)),
          )
        ],
      ),
    );
  }
}
