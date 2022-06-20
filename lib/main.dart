import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/enums.dart';
import 'components/theme.dart';
import 'providers/google_signin_provider.dart';
import 'routes.dart';
import 'screens/home.dart';
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
          theme: notifier.isDark ? dark : light,
          home: Home(),
          routes: routes,
        );
      }),
    );
  }
}
