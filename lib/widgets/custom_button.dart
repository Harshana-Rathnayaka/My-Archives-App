import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/enums.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final Color btnColor;
  final Color textColor;
  final IconData icon;
  final String text;

  const CustomButton({Key? key, required this.onTap, this.btnColor = colorGreen, this.textColor = colorWhite, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(color: connectionStatus != ConnectivityStatus.Offline ? btnColor : Colors.grey, borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(icon, color: textColor),
              SizedBox(width: 8),
              Text(text, style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
