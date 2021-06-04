import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../utils/helper_methods.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/helper_widgets.dart';
import 'watched_movies.dart';
import 'watchlist.dart';

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

  final user = FirebaseAuth.instance.currentUser;

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
                    displayIcon: Icons.movie_outlined,
                    title: 'MOVIES',
                    onPressed: () {
                      launchScreen(context, WatchedMovies.tag);
                    },
                  ),
                  DashboardCard(
                    displayIcon: Icons.live_tv,
                    title: 'TV SERIES',
                    onPressed: () {},
                  ),
                  DashboardCard(
                    displayIcon: Icons.bookmark,
                    title: 'WATCHLIST',
                    onPressed: () {
                      launchScreen(context, Watchlist.tag);
                    },
                  ),
                  DashboardCard(
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
