import 'package:flutter/material.dart';

import 'package:my_archive/constants/fonts.dart';

class DashboardCard extends StatelessWidget {
  final IconData displayIcon;
  final String title;
  final Function onPressed;
  final String tooltip;
  const DashboardCard({
    @required this.displayIcon,
    @required this.title,
    @required this.onPressed,
    @required this.tooltip,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Tooltip(
        message: tooltip,
        child: Card(
          elevation: 10,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).accentColor.withOpacity(0.2)),
                  child: Icon(displayIcon,
                      color: Theme.of(context).accentColor, size: 28),
                ),
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
      ),
    );
  }
}
