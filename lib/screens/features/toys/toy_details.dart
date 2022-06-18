import 'package:flutter/material.dart';

import '../../../constants/fonts.dart';
import '../../../models/toy.dart';
import '../../../utils/helper_methods.dart';
import '../../../widgets/gallery_view.dart';
import '../../../widgets/helper_widgets.dart';
import 'components/description_section.dart';
import 'components/edit_button.dart';
import 'components/toy_details_table.dart';

class ToyDetails extends StatefulWidget {
  static var tag = "/ToyDetails";
  const ToyDetails({Key? key}) : super(key: key);

  @override
  State<ToyDetails> createState() => _ToyDetailsState();
}

class _ToyDetailsState extends State<ToyDetails> {
  late Size size;
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    Toy toy = ModalRoute.of(context)!.settings.arguments as Toy;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => launchScreen(context, GalleryView.tag, arguments: {'images': toy.images, 'selectedIndex': selectedImage}),
                child: SizedBox(
                  width: size.width,
                  height: size.width,
                  child: AspectRatio(aspectRatio: 1, child: Hero(tag: toy.images[selectedImage], child: ImageWidget(imageUrl: toy.images[selectedImage], noDecoration: true))),
                ),
              ),
              CustomBackButton()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [...List.generate(toy.images.length, (index) => imagePreview(toy.images, index))],
          ),
          DescriptionSection(
            children: [
              EditButton(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(toy.modelName, style: Theme.of(context).textTheme.headline6!.copyWith(fontFamily: fontSemiBold)),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20), child: ToyDetailsTable(toy: toy))
            ],
          ),
        ],
      ),
    );
  }

  // small image preview boxes
  GestureDetector imagePreview(List images, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedImage = index),
      child: Container(
        child: ImageWidget(imageUrl: images[index]),
        margin: const EdgeInsets.only(right: 15, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 2, color: selectedImage == index ? Theme.of(context).colorScheme.secondary : Colors.transparent),
        ),
      ),
    );
  }
}
