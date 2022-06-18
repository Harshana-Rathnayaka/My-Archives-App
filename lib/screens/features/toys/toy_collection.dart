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
import 'toy_details.dart';

class ToyCollection extends StatefulWidget {
  static var tag = "/ToyCollection";
  const ToyCollection({Key? key}) : super(key: key);

  @override
  State<ToyCollection> createState() => _ToyCollectionState();
}

class _ToyCollectionState extends State<ToyCollection> {
  List toys = [];
  final user = FirebaseAuth.instance.currentUser;
  bool isItemSelected = false;
  late int selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isItemSelected ? null : AppBarTitle(title: 'Toy Collection'),
        leading: IconButton(onPressed: () => isItemSelected ? setState(() => isItemSelected = false) : finish(context), icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(isItemSelected ? Icons.delete : Icons.search), onPressed: () => showSearch(context: context, delegate: Search(itemList: toys))),
          isItemSelected ? IconButton(onPressed: () {}, icon: Icon(Icons.edit)) : Container(),
          isItemSelected ? IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)) : Container(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Toy>>(
        stream: ToyService(uid: user!.uid).getToyCollectionStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Toy>> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Something went wrong. \n Error - ${snapshot.error}', style: TextStyle(fontFamily: fontRegular, fontWeight: FontWeight.bold)));

          final data = snapshot.requireData;

          return ListView.builder(
              itemCount: data.size,
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              itemBuilder: (context, index) {
                Toy toy = data.docs[index].data();

                return GestureDetector(
                  onTap: () {
                    if (index != selectedItem) setState(() => isItemSelected = false);
                    launchScreen(context, ToyDetails.tag, arguments: toy);
                  },
                  onLongPress: () => setState(() {
                    isItemSelected = true;
                    selectedItem = index;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: isItemSelected && selectedItem == index ? Border.all(color: Theme.of(context).colorScheme.secondary) : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Hero(tag: toy.images[0], child: ImageWidget(imageUrl: toy.images[0])),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(toy.modelName, style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.bold, fontSize: textSizeSMedium)),
                                    Text('${toy.year} ${toy.brand} ${toy.type ?? ''}', style: TextStyle(fontFamily: fontRegular, fontSize: textSizeSmall)),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: toy.modelNumber != null,
                                  child: Text(toy.modelNumber ?? '', style: TextStyle(fontFamily: fontBold, fontSize: textSizeExtraSmall)),
                                ),
                                Visibility(
                                  visible: toy.castingNumber != null,
                                  child: Text(toy.castingNumber ?? '', style: TextStyle(fontFamily: fontBold, fontSize: textSizeExtraSmall)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
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
