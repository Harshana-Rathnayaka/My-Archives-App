import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'components/connectivity_status.dart';
import 'components/theme.dart';
import 'providers/google_signin_provider.dart';
import 'screens/features/toys/add_new_toy.dart';
import 'screens/features/toys/toy_collection.dart';
import 'screens/features/toys/toy_details.dart';
// import 'screens/dashboard.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/watched_movies.dart';
import 'screens/watched_tv_series.dart';
import 'screens/watchlist.dart';
import 'services/connectivity_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>.value(value: ConnectivityService().connectionStatusController.stream, initialData: ConnectivityStatus.Offline),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier())
      ],
      child: Consumer<ThemeNotifier>(builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: notifier.isDark! ? dark : light,
          home: Home(),
          routes: <String, WidgetBuilder>{
            Login.tag: (BuildContext context) => Login(),
            // Dashboard.tag: (BuildContext context) => Dashboard(),
            Watchlist.tag: (BuildContext context) => Watchlist(),
            WatchedMovies.tag: (BuildContext context) => WatchedMovies(),
            WatchedTvSeries.tag: (BuildContext context) => WatchedTvSeries(),
            ToyCollection.tag: (BuildContext context) => ToyCollection(),
            AddNewToy.tag: (BuildContext context) => AddNewToy(),
            ToyDetails.tag: (BuildContext context) => ToyDetails(),
          },
        );
      }),
    );
  }
}
