import 'package:flutter/material.dart';

import 'screens/dashboard.dart';
import 'screens/features/toys/add_new_toy.dart';
import 'screens/features/toys/toy_collection.dart';
import 'screens/features/toys/toy_details.dart';
import 'screens/login.dart';
import 'screens/watched_movies.dart';
import 'screens/watched_tv_series.dart';
import 'screens/watchlist.dart';

final Map<String, WidgetBuilder> routes = {
  Login.tag: (BuildContext context) => Login(),
  Dashboard.tag: (BuildContext context) => Dashboard(),
  Watchlist.tag: (BuildContext context) => Watchlist(),
  WatchedMovies.tag: (BuildContext context) => WatchedMovies(),
  WatchedTvSeries.tag: (BuildContext context) => WatchedTvSeries(),
  ToyCollection.tag: (BuildContext context) => ToyCollection(),
  AddNewToy.tag: (BuildContext context) => AddNewToy(),
  ToyDetails.tag: (BuildContext context) => ToyDetails(),
};
