import 'package:flutter/material.dart';

import 'package:my_archive/constants/fonts.dart';

class DashboardCard extends StatelessWidget {
  final IconData displayIcon;
  final String title;
  final Function onPressed;
  const DashboardCard({
    @required this.displayIcon,
    @required this.title,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 10,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(displayIcon, color: Theme.of(context).accentColor, size: 40),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                    letterSpacing: 1.0,
                    fontFamily: fontRegular,
                    fontSize: textSizeLargeMedium),
              )
            ],
          ),
        ),
      ),
    );
  }
}
