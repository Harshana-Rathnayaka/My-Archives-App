import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/toy.dart';

class ToyService {
  final String uid;
  // final FirebaseStorage _firebaseStorage = FirebaseStorage.instance();
  final CollectionReference toysReference = FirebaseFirestore.instance.collection('toys');
  late CollectionReference toyCollectionReference = toysReference.doc(uid).collection('toyCollection').withConverter<Toy>(
        fromFirestore: (snapshots, _) => Toy.fromJson(snapshots.data()!),
        toFirestore: (toy, _) => toy.toJson(),
      );

  ToyService({required this.uid});

  // getting the toy collection for each user
  getToyCollectionStream() => toyCollectionReference.snapshots();

  // add to toys collection
  Future addToy({required Toy toyDetails}) async {
    String uniqueId = DateTime.now().microsecondsSinceEpoch.toString();
    await toyCollectionReference.doc(uniqueId).set(toyDetails);
  }

  // deleting a movie
  Future deleteToy({required Toy toy}) async => await toyCollectionReference.doc(toy.documentId).delete();
}
