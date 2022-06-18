import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/theme.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../utils/helper_methods.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontFamily: fontRegular, letterSpacing: 1.0, wordSpacing: 1.0, fontWeight: FontWeight.bold));
  }
}

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final bool noDecoration;
  const ImageWidget({Key? key, required this.imageUrl, this.width = 50, this.height = 50, this.noDecoration = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error, size: 24, color: colorRed),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            boxShadow: noDecoration ? null : [BoxShadow(spreadRadius: 0.5, blurRadius: 4.0, offset: Offset(2.0, 0.1))],
            borderRadius: BorderRadius.circular(noDecoration ? 0 : 24),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier theme = Provider.of<ThemeNotifier>(context);

    return Positioned(
      top: 50,
      left: 20,
      child: InkWell(
        onTap: () => finish(context),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, color: theme.isDark ? colorWhite.withOpacity(0.4) : colorBlack.withOpacity(0.5)),
          child: Icon(Icons.arrow_back, color: colorWhite),
        ),
      ),
    );
  }
}
