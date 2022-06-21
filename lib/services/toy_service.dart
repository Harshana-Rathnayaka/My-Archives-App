import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/toy.dart';

class ToyService {
  final String uid;
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
    await toyCollectionReference.doc(uniqueId).set(toyDetails.copyWith(documentId: uniqueId));
  }

  // deleting a toy
  Future deleteToy({required Toy toy}) async {
    toy.images.forEach((element) async => await FirebaseStorage.instance.refFromURL(element).delete());
    await toyCollectionReference.doc(toy.documentId).delete();
  }
}
