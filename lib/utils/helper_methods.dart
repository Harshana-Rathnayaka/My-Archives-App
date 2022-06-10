import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

launchScreen(context, String tag, {Object? arguments}) {
  if (arguments == null) {
    Navigator.pushNamed(context, tag);
  } else {
    Navigator.pushNamed(context, tag, arguments: arguments);
  }
}

void launchScreenWithNewTask(context, String tag, {Object? arguments}) {
  if (arguments == null) {
    Navigator.pushNamedAndRemoveUntil(context, tag, (r) => false);
  } else {
    Navigator.pushNamedAndRemoveUntil(context, tag, (r) => false, arguments: arguments);
  }
}

void finish(context, {dynamic val = false}) {
  Navigator.pop(context, val);
}

back(var context) {
  Navigator.pop(context);
}

void hideKeyboard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

SnackBar customSnackbar({required IconData icon, required Color iconColor, required String text}) {
  return SnackBar(
    content: Row(
      children: [
        Icon(icon, color: iconColor),
        SizedBox(width: 12),
        Text(text, style: const TextStyle(fontFamily: fontRegular, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

void showToast({required String msg, required Color backGroundColor}) => Fluttertoast.showToast(msg: msg, textColor: colorWhite, backgroundColor: backGroundColor, toastLength: Toast.LENGTH_LONG);
