import 'package:cloud_firestore/cloud_firestore.dart';

class ToyService {
  final String uid;
  final CollectionReference toys = FirebaseFirestore.instance.collection('toys');

  ToyService({required this.uid});

// add to toys collection
  Future addToy({required Map<String, dynamic> toyDetails}) async {
    String uniqueId = DateTime.now().microsecondsSinceEpoch.toString();
    CollectionReference toyCollection = toys.doc(uid).collection('toyCollection');
    await toyCollection.doc(uniqueId).set(toyDetails);
  }
}
