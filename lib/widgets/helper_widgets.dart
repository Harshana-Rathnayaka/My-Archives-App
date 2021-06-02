import 'package:flutter/material.dart';

import '../constants/fonts.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontFamily: fontRegular,
          letterSpacing: 1.0,
          wordSpacing: 1.0,
          fontWeight: FontWeight.bold),
    );
  }
}
