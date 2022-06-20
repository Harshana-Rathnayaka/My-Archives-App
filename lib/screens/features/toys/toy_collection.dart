import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/fonts.dart';
import '../../../models/toy.dart';
import '../../../services/toy_service.dart';
import '../../../utils/helper_methods.dart';
import '../../../widgets/helper_widgets.dart';
import 'add_new_toy.dart';
import 'toy_details.dart';
import 'toy_search.dart';

class ToyCollection extends StatefulWidget {
  static var tag = "/ToyCollection";
  const ToyCollection({Key? key}) : super(key: key);

  @override
  State<ToyCollection> createState() => _ToyCollectionState();
}

class _ToyCollectionState extends State<ToyCollection> {
  final user = FirebaseAuth.instance.currentUser;
  late Size size;
  List<Toy> toys = [];
  bool isItemSelected = false;
  int selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: isItemSelected ? null : AppBarTitle(title: 'Toy Collection'),
        leading: IconButton(onPressed: () => isItemSelected ? setState(() => isItemSelected = false) : finish(context), icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        actions: [
          isItemSelected ? IconButton(onPressed: () {}, icon: Icon(Icons.delete)) : Container(),
          isItemSelected ? IconButton(onPressed: () {}, icon: Icon(Icons.edit)) : Container(),
          isItemSelected ? IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)) : Container(),
          !isItemSelected ? IconButton(icon: Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: ToySearch(itemList: toys))) : Container(),
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
                if (toys.length != data.size) toys.add(toy); // list for searching

                return GestureDetector(
                  onTap: () {
                    if (index != selectedItemIndex) setState(() => isItemSelected = false);
                    launchScreen(context, ToyDetails.tag, arguments: toy);
                  },
                  onLongPress: () => setState(() {
                    isItemSelected = true;
                    selectedItemIndex = index;
                  }),
                  child: Card(
                    elevation: 10,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: isItemSelected && selectedItemIndex == index ? Theme.of(context).colorScheme.secondary : Colors.transparent),
                    ),
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Hero(tag: toy.images[0], child: ImageWidget(imageUrl: toy.images[0])),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(toy.modelName, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.bold, fontSize: textSizeSMedium)),
                                    Text('${toy.year} ${toy.brand} ${toy.type ?? ''}',
                                        overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(fontFamily: fontRegular, fontSize: textSizeSmall)),
                                  ],
                                ),
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
