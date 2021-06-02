import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_archive/services/UserService.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final firebaseInstance = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

// login method
  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();

    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // getting the result
      final UserCredential authResult =
          await firebaseInstance.signInWithCredential(credential);

      // getting the logged in user from the result
      final User loggedInUser = authResult.user;

      print(loggedInUser.uid);
      print(loggedInUser.displayName);
      print(loggedInUser.email);

// adding the user details to the users collection after login
      addUser(uid: loggedInUser.uid, userData: {
        "uid": loggedInUser.uid,
        "name": loggedInUser.displayName,
        "email": loggedInUser.email,
        "photoURL": loggedInUser.photoURL
      }).onError((error, stackTrace) {
        print('some error - $error');
        print(stackTrace);
      }).then((value) {
        print('success $value');
      });

      isSigningIn = false;
    }
  }

// logout method
  void logout() async {
    await googleSignIn.disconnect();
    firebaseInstance.signOut();
  }

  //  add user details to firestore
  Future addUser({uid, userData}) async {
    await _usersCollection.doc(uid).set(userData);
  }
}
