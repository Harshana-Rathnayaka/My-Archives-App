import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final firebaseInstance = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  bool? _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool? get isSigningIn => _isSigningIn;

  set isSigningIn(bool? isSigningIn) {
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
      final User loggedInUser = authResult.user!;

      print(loggedInUser.uid);
      print(loggedInUser.displayName);
      print(loggedInUser.email);

      // creating docs for the user in other collections
      createDocs(uid: loggedInUser.uid);

      // adding the user details to the users collection after login
      addUser(uid: loggedInUser.uid, userData: {
        "uid": loggedInUser.uid,
        "name": loggedInUser.displayName,
        "email": loggedInUser.email,
        "photoURL": loggedInUser.photoURL
      }).onError((dynamic error, stackTrace) {
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

  // add user details to firestore
  Future addUser({uid, userData}) async {
    await _usersCollection.doc(uid).set(userData);
  }

  // create docs with uid in other collections (only if it does not exist)
  Future createDocs({uid}) async {
    print('checking doc availability');

    final movieCollection =
        FirebaseFirestore.instance.collection('watchedMovies');
    final tvSeriesCollection =
        FirebaseFirestore.instance.collection('watchedTvSeries');
    final watchlistCollection =
        FirebaseFirestore.instance.collection('watchlist');

    // checking whether docs exist under this uid and creating a doc if it does not exist
    DocumentSnapshot movieDbDoc = await movieCollection.doc(uid).get();
    DocumentSnapshot tvSeriesDoc = await tvSeriesCollection.doc(uid).get();
    DocumentSnapshot watchlistDbDoc = await watchlistCollection.doc(uid).get();

    if (movieDbDoc.exists) {
      print('doc exists in watchedMovies');
    } else {
      print('creating doc in watchedMovies');
      await movieCollection.doc(uid).set({"movies": []});
    }

    if (tvSeriesDoc.exists) {
      print('doc exists in watchedTvSeries');
    } else {
      print('creating doc in watchedTvSeries');
      await tvSeriesCollection.doc(uid).set({"tvSeries": []});
    }

    if (watchlistDbDoc.exists) {
      print('doc exists in watchlist');
    } else {
      print('creating doc in watchlist');
      await watchlistCollection.doc(uid).set({"movies": [], "tvSeries": []});
    }
  }
}
