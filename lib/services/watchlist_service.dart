import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistService {
  final String? uid;

  WatchlistService({this.uid});
  final CollectionReference _watchlistCollection = FirebaseFirestore.instance.collection('watchlist');

  //  add watchlist to the db
  Future addToWatchlist({type, watchlistData}) async {
    // getting the document from uid
    DocumentSnapshot dbDoc = await _watchlistCollection.doc(uid).get();
    print(dbDoc.exists);

    // checking if the document exists
    if (dbDoc.exists) {
      // if it exists --> the list will be updated
      if (type == 'movies') {
        await _watchlistCollection.doc(uid).update({"movies": FieldValue.arrayUnion(watchlistData)});
      } else {
        await _watchlistCollection.doc(uid).update({"tvSeries": FieldValue.arrayUnion(watchlistData)});
      }
    } else {
      // if it does not exist --> the list will be created
      if (type == 'movies') {
        await _watchlistCollection.doc(uid).set({"movies": FieldValue.arrayUnion(watchlistData)});
      } else {
        await _watchlistCollection.doc(uid).set({"tvSeries": FieldValue.arrayUnion(watchlistData)});
      }
    }
  }
}
