import 'package:cloud_firestore/cloud_firestore.dart';

class WatchedMovieService {
  final String uid;

  WatchedMovieService({this.uid});

  final movieCollection =
      FirebaseFirestore.instance.collection('watchedMovies');

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
}
