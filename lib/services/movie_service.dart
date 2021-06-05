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
  Future addWatchedMovies({List<Map<String, dynamic>> data}) async {
    print('adding');
    print(data);

    DocumentSnapshot dbDoc = await movieCollection.doc(uid).get();

    if (!dbDoc.exists) {
      return await movieCollection
          .doc(uid)
          .set({"movies": FieldValue.arrayUnion(data)});
    }

    return await movieCollection
        .doc(uid)
        .update({"movies": FieldValue.arrayUnion(data)});
  }

// updatin movie details
  Future updateWatchedMovieDetails({List<Map<String, dynamic>> data}) async {
    print('updating');
    print(data);

    print('removing and adding');
    return await movieCollection
        .doc(uid)
        .update({"movies": FieldValue.arrayRemove(data)})
        .then((value) => movieCollection
            .doc(uid)
            .update({"movies": FieldValue.arrayUnion(data)}))
        .then((value) => print('after adding'));
  }
}
