import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final firebaseInstance = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  // login method
  Future googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      _user = googleUser;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final UserCredential authResult = await firebaseInstance.signInWithCredential(credential);
      final User loggedInUser = authResult.user!;

      // after login (create documents and add user details to db)
      createDocs(uid: loggedInUser.uid);
      addUser(uid: loggedInUser.uid, userData: {
        "uid": loggedInUser.uid,
        "name": loggedInUser.displayName,
        "email": loggedInUser.email,
        "photoURL": loggedInUser.photoURL,
      }).onError((dynamic error, stackTrace) {
        log('some error - $error');
        log(stackTrace.toString());
      });
    } catch (e) {
      log(e.toString());
    }

    notifyListeners();
  }

  // logout method
  Future logout() async {
    await googleSignIn.disconnect();
    firebaseInstance.signOut();
  }

  // add user details to firestore
  Future addUser({uid, userData}) async => await _usersCollection.doc(uid).set(userData);

  // create docs with uid in other collections (only if it does not exist)
  Future createDocs({uid}) async {
    final movieCollection = FirebaseFirestore.instance.collection('watchedMovies');
    final tvSeriesCollection = FirebaseFirestore.instance.collection('watchedTvSeries');
    final watchlistCollection = FirebaseFirestore.instance.collection('watchlist');

    // checking whether docs exist under this uid and creating a doc if it does not exist
    DocumentSnapshot movieDbDoc = await movieCollection.doc(uid).get();
    DocumentSnapshot tvSeriesDoc = await tvSeriesCollection.doc(uid).get();
    DocumentSnapshot watchlistDbDoc = await watchlistCollection.doc(uid).get();

    if (!movieDbDoc.exists) await movieCollection.doc(uid).set({"movies": []});

    if (!tvSeriesDoc.exists) await tvSeriesCollection.doc(uid).set({"tvSeries": []});

    if (!watchlistDbDoc.exists) await watchlistCollection.doc(uid).set({"movies": [], "tvSeries": []});
  }
}
