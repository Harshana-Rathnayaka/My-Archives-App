import 'package:flutter/material.dart';

import '../constants/images.dart';
import '../screens/watchlist.dart';
import '../utils/helper_methods.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/helper_widgets.dart';

class Dashboard extends StatefulWidget {
  static var tag = "/Dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(title: 'My Archives'),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Expanded(
              child: GridView(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: [
                  DashboardCard(
                    isIcon: false,
                    displayIcon: movies,
                    title: 'MOVIES',
                    onPressed: () {},
                  ),
                  DashboardCard(
                    isIcon: true,
                    displayIcon: Icons.tv,
                    title: 'TV SERIES',
                    onPressed: () {},
                  ),
                  DashboardCard(
                    isIcon: true,
                    displayIcon: Icons.bookmark,
                    title: 'WATCHLIST',
                    onPressed: () {
                      launchScreen(context, Watchlist.tag);
                    },
                  ),
                  DashboardCard(
                    isIcon: true,
                    displayIcon: Icons.location_pin,
                    title: 'PLACES',
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
