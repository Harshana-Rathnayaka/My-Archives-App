import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../constants/fonts.dart';
import '../constants/images.dart';

class CustomNoRecords extends StatelessWidget {
  final String text;
  const CustomNoRecords({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(empty, height: 80),
        Center(
          child: Text(
            text,
            style: TextStyle(fontFamily: fontRegular, fontSize: textSizeMedium),
          ),
        ),
      ],
    );
  }
}
