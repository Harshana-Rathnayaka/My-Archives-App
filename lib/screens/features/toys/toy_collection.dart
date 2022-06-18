import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
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
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              itemBuilder: (context, index) {
                Toy toy = data.docs[index].data();

                return GestureDetector(
                  onTap: () => launchScreen(context, ToyDetails.tag, arguments: toy),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Hero(
                                  tag: toy.images[0],
                                  child: CachedNetworkImage(
                                    width: 60,
                                    height: 50,
                                    imageUrl: toy.images[0],
                                    placeholder: (context, url) => new Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => new Icon(Icons.error, size: 26, color: colorRed),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.5), offset: Offset(1.0, 2.0), blurRadius: 3.0)],
                                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                    ),
                                  ),
                                ),
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
