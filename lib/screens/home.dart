import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

// import 'dashboard.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Login();
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
