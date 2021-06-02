import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_archive/components/theme.dart';
import 'package:my_archive/providers/google_signin_provider.dart';
import 'package:my_archive/screens/dashboard.dart';
import 'package:my_archive/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'components/connectivity_status.dart';
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
        StreamProvider<ConnectivityStatus>.value(
          value: ConnectivityService().connectionStatusController.stream,
          initialData: ConnectivityStatus.Offline,
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: notifier.isDark ? dark : light,
            home: ChangeNotifierProvider(
              create: (_) => GoogleSignInProvider(),
              child: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    final provider = Provider.of<GoogleSignInProvider>(context);

                    if (provider.isSigningIn) {
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Dashboard();
                    } else {
                      return Login();
                    }
                  }),
            ),
            routes: <String, WidgetBuilder>{
              Login.tag: (BuildContext context) => Login(),
              Dashboard.tag: (BuildContext context) => Dashboard(),
            },
          );
        }),
      ),
    );
  }
}
