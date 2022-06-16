import 'package:flutter/material.dart';

import '../../../constants/fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: 'Toy Collection'),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: Search(itemList: toys)))],
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
