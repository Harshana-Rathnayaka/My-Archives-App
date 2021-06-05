import 'package:cloud_firestore/cloud_firestore.dart';

class WatchedMovieService {
  final String uid;

  WatchedMovieService({this.uid});

  final movieCollection =
      FirebaseFirestore.instance.collection('watchedMovies');

// getting the watched movies collection
  Stream<DocumentSnapshot<Map<String, dynamic>>> getWatchedMoviesStream() {
    return FirebaseFirestore.instance
        .collection('watchedMovies')
        .doc(uid)
        .snapshots();
  }

// add to watched movies collection
  Future addWatchedMovies({List<Map<String, dynamic>> movieToAdd}) async {
    print('adding');
    print(movieToAdd);

    DocumentSnapshot dbDoc = await movieCollection.doc(uid).get();

    if (!dbDoc.exists) {
      return await movieCollection
          .doc(uid)
          .set({"movies": FieldValue.arrayUnion(movieToAdd)});
    }

    return await movieCollection
        .doc(uid)
        .update({"movies": FieldValue.arrayUnion(movieToAdd)});
  }

// updating movie details
  Future updateWatchedMovieDetails(
      {List<Map<String, dynamic>> movieToRemove,
      List<Map<String, dynamic>> movieToUpdate}) async {
    print('updating');
    print(movieToRemove);
    print(movieToUpdate);

    print('removing and adding');
    return await movieCollection
        .doc(uid)
        .update({"movies": FieldValue.arrayRemove(movieToRemove)})
        .then((value) => movieCollection
            .doc(uid)
            .update({"movies": FieldValue.arrayUnion(movieToUpdate)}))
        .then((value) => print('after adding'));
  }

  // deleting a movie
  Future deleteWatchedMovie({List<Map<String, dynamic>> data}) async {
    print('deleting');
    print(data);

    return await movieCollection
        .doc(uid)
        .update({"movies": FieldValue.arrayRemove(data)});
  }
}
