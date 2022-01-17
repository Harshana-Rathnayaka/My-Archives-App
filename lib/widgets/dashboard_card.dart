import 'package:flutter/material.dart';

import 'package:my_archive/constants/fonts.dart';

class DashboardCard extends StatelessWidget {
  final IconData displayIcon;
  final String title;
  final String description;
  final Function onPressed;
  final String tooltip;
  const DashboardCard({
    @required this.displayIcon,
    @required this.title,
    @required this.description,
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
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
                  child: Icon(displayIcon, color: Theme.of(context).colorScheme.secondary, size: 28),
                ),
                SizedBox(height: 10),
                Text(title, style: TextStyle(letterSpacing: 0.2, fontFamily: fontBold, fontSize: textSizeMedium)),
                Text(description, style: TextStyle(fontFamily: fontRegular, fontSize: textSizeSmall))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
