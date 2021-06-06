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
    return Scaffold(
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
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                DashboardCard(
                  displayIcon: Icons.movie_outlined,
                  title: 'MOVIES',
                  tooltip: 'Watched movies',
                  onPressed: () {
                    launchScreen(context, WatchedMovies.tag);
                  },
                ),
                DashboardCard(
                  displayIcon: Icons.live_tv,
                  title: 'TV SERIES',
                  tooltip: 'Watched tv series',
                  onPressed: () {},
                ),
                DashboardCard(
                  displayIcon: Icons.bookmark,
                  title: 'WATCHLIST',
                  tooltip: 'Movies and tv series to watch',
                  onPressed: () {
                    launchScreen(context, Watchlist.tag);
                  },
                ),
                DashboardCard(
                  displayIcon: Icons.location_pin,
                  title: 'PLACES',
                  tooltip: 'Places that I have been to',
                  onPressed: () {},
                ),
                DashboardCard(
                  displayIcon: Icons.monetization_on,
                  title: 'EXPENSES',
                  tooltip: 'Monthly expenses',
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
