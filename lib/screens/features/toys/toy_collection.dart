import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/fonts.dart';
import '../../../models/toy.dart';
import '../../../services/toy_service.dart';
import '../../../utils/helper_methods.dart';
import '../../../widgets/helper_widgets.dart';
import '../../../widgets/search.dart';
import 'add_new_toy.dart';

class ToyCollection extends StatefulWidget {
  static var tag = "/ToyCollection";

  const ToyCollection({Key? key}) : super(key: key);

  @override
  State<ToyCollection> createState() => _ToyCollectionState();
}

class _ToyCollectionState extends State<ToyCollection> {
  List toys = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: 'Toy Collection'),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: Search(itemList: toys)))],
      ),
      body: StreamBuilder<QuerySnapshot<Toy>>(
        stream: ToyService(uid: user!.uid).getToyCollectionStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Toy>> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Something went wrong. \n Error - ${snapshot.error}', style: TextStyle(fontFamily: fontRegular, fontWeight: FontWeight.bold)));

          final data = snapshot.requireData;

          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                Toy toy = data.docs[index].data();
                return Text(toy.modelName);
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add new toy', style: TextStyle(fontFamily: fontMedium)),
        icon: Icon(Icons.add_box),
        onPressed: () => launchScreen(context, AddNewToy.tag),
      ),
    );
  }
}
