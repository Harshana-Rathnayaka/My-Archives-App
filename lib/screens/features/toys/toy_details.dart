import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/theme.dart';
import '../../../constants/colors.dart';
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
    ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    size = MediaQuery.of(context).size;
    Toy toy = ModalRoute.of(context)!.settings.arguments as Toy;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => viewImage(toy.images, selectedImage),
                child: SizedBox(
                  width: size.width,
                  height: size.width,
                  child: AspectRatio(aspectRatio: 1, child: Hero(tag: toy.images[selectedImage], child: ImageWidget(imageUrl: toy.images[selectedImage], noDecoration: true))),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: InkWell(
                  onTap: () => finish(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.isDark ? colorWhite.withOpacity(0.4) : colorBlack.withOpacity(0.5),
                    ),
                    child: Icon(Icons.arrow_back, color: colorWhite),
                  ),
                ),
              ),
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

  // open image to look more closely
  void viewImage(List images, selectedIndex) => launchScreen(context, GalleryView.tag, arguments: {'images': images, 'selectedIndex': selectedIndex});

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
