import 'package:cloud_firestore/cloud_firestore.dart';

class WatchedTvSeriesService {
  final String? uid;

  WatchedTvSeriesService({this.uid});

  final tvSeriesCollection =
      FirebaseFirestore.instance.collection('watchedTvSeries');

// getting the watched tv series collection
  Stream<DocumentSnapshot<Map<String, dynamic>>>
      getWatchedTvSeriesCollection() {
    return FirebaseFirestore.instance
        .collection('watchedTvSeries')
        .doc(uid)
        .snapshots();
  }

// add to watched tv series collection
  Future addWatchedTvSeries({List<Map<String, dynamic>>? tvSeriesToAdd}) async {
    print('adding');
    print(tvSeriesToAdd);

    DocumentSnapshot dbDoc = await tvSeriesCollection.doc(uid).get();

    if (!dbDoc.exists) {
      return await tvSeriesCollection
          .doc(uid)
          .set({"tvSeries": FieldValue.arrayUnion(tvSeriesToAdd!)});
    }

    return await tvSeriesCollection
        .doc(uid)
        .update({"tvSeries": FieldValue.arrayUnion(tvSeriesToAdd!)});
  }

// updating tv series details
  Future updateTvSeriesDetails(
      {required List<Map<String, dynamic>> tvSeriesToRemove,
      List<Map<String, dynamic>>? tvSeriesToUpdate}) async {
    print('updating');
    print(tvSeriesToRemove);
    print(tvSeriesToUpdate);

    print('removing and adding');
    return await tvSeriesCollection
        .doc(uid)
        .update({"tvSeries": FieldValue.arrayRemove(tvSeriesToRemove)})
        .then((value) => tvSeriesCollection
            .doc(uid)
            .update({"tvSeries": FieldValue.arrayUnion(tvSeriesToUpdate!)}))
        .then((value) => print('after adding'));
  }

  // deleting a tv series
  Future deleteWatchedTvSeries({required List<Map<String, dynamic>> data}) async {
    print('deleting');
    print(data);

    return await tvSeriesCollection
        .doc(uid)
        .update({"tvSeries": FieldValue.arrayRemove(data)});
  }
}
