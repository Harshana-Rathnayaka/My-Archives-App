import 'package:flutter/material.dart';

import '../../../utils/helper_methods.dart';
import '../../../widgets/helper_widgets.dart';
import '../../../widgets/search.dart';
import 'add_new_toy.dart';

class ToyDetails extends StatefulWidget {
  static var tag = "/ToyDetails";

  const ToyDetails({Key? key}) : super(key: key);

  @override
  State<ToyDetails> createState() => _ToyDetailsState();
}

class _ToyDetailsState extends State<ToyDetails> {
  List toys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: 'Toy Details'),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: Search(itemList: toys)))],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () => launchScreen(context, AddNewToy.tag)),
    );
  }
}
