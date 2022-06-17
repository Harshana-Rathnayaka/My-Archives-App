import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../components/connectivity_status.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/custom_dropdown_field.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/helper_widgets.dart';

class AddNewToy extends StatefulWidget {
  static var tag = "/AddNewToy";

  const AddNewToy({Key? key}) : super(key: key);

  @override
  State<AddNewToy> createState() => _AddNewToyState();
}

class _AddNewToyState extends State<AddNewToy> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _year = TextEditingController();
  MaskedTextController _modelNumber = MaskedTextController(mask: '000/000');
  MaskedTextController _castingNumber = MaskedTextController(mask: '@@@@@-@@@@@');
  TextEditingController _modelName = TextEditingController();
  TextEditingController _description = TextEditingController();
  MoneyMaskedTextController _price = MoneyMaskedTextController(initialValue: 0.00, decimalSeparator: '.', leftSymbol: 'Rs. ', thousandSeparator: ',');

  late Size size;
  List imageList = [
    {"name": "placeholder", "url": ""}
  ];
  List<String> brands = ['Hot Wheels', 'Matchbox', 'Tarmac Works', 'Mini GT'];
  List<String> type = ['Basic (Mainline)', 'Premium'];
  String? selectedBrand;
  String? selectedType;
  DateTime selectedDate = DateTime.now();
  bool isImageError = false;
  bool isLoading = false;

  late final AnimationController _animationController;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 20));
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) _animationController.reverse();
    });

    animation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _year.dispose();
    _modelNumber.dispose();
    _castingNumber.dispose();
    _modelName.dispose();
    _description.dispose();
    _price.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(title: 'Add New Toy'), centerTitle: true),
      body: CustomLoader(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: size.width / 2.5,
                    child: GridView.builder(
                        itemCount: imageList.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 10, mainAxisExtent: imageList.length <= 1 ? size.width - 20 : null),
                        itemBuilder: (context, index) {
                          return index != 0
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Container(
                                    margin: const EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      boxShadow: [BoxShadow(offset: Offset(0.0, 0.0), blurRadius: 1.0)],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4.0),
                                          child: Image.file(
                                            File(imageList[index]['url']),
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                            errorBuilder: (context, url, error) => Center(child: new Icon(Icons.error, size: 40, color: colorRed)),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                            child: InkWell(
                                              onTap: () => setState(() => imageList.removeAt(index)),
                                              child: Icon(Icons.cancel, size: 24, color: colorRed),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : AnimatedBuilder(
                                  animation: _animationController.view,
                                  builder: (context, child) => Transform.rotate(angle: _animationController.value * 0.04, child: child),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Container(
                                      margin: const EdgeInsets.all(1.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),
                                        color: Theme.of(context).cardColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: isImageError == true ? colorRed : Theme.of(context).colorScheme.secondary,
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(onPressed: () => captureImage(), icon: Icon(Icons.camera_alt), iconSize: 30),
                                          GestureDetector(
                                            onTap: () => captureImage(false),
                                            child: Text('or \n select from gallery', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontFamily: fontMedium)),
                                          ),
                                          Visibility(
                                            visible: isImageError,
                                            child: Expanded(
                                              child: Column(
                                                children: [
                                                  Spacer(),
                                                  Text(
                                                    'At least one image is required',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontFamily: fontMedium, fontSize: textSizeSmall, color: Theme.of(context).errorColor),
                                                  ),
                                                  SizedBox(height: 10)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        }),
                  ),
                  SizedBox(height: 12),
                  CustomDropDownField(
                    hint: 'Diecast Brand',
                    items: brands.map((value) => DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontFamily: fontMedium, fontSize: 14)))).toList(),
                    selectedValue: selectedBrand,
                    validation: (String? val) => val == null ? 'Brand is required' : null,
                    onChanged: (val) => setState(() => selectedBrand = val),
                  ),
                  Visibility(
                    visible: selectedBrand == 'Hot Wheels',
                    child: CustomDropDownField(
                      hint: 'Type',
                      items: type.map((value) => DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontFamily: fontMedium, fontSize: 14)))).toList(),
                      selectedValue: selectedType,
                      validation: (String? val) => selectedBrand == 'Hot Wheels' && val == null ? 'Type is required' : null,
                      onChanged: (val) => setState(() => selectedType = val),
                    ),
                  ),
                  CustomDatePicker(hint: 'Year', controller: _year, validation: (String? val) => val == '' ? 'Year is required' : null),
                  CustomTextField(controller: _modelName, hint: 'Model Name', validation: (String? val) => val!.isEmpty ? 'Car name is required' : null),
                  Visibility(visible: selectedBrand == 'Hot Wheels', child: CustomTextField(controller: _modelNumber, hint: 'Model Number (Front)', validation: (String? val) => null, isNumber: true)),
                  Visibility(
                    visible: selectedBrand == 'Hot Wheels' || selectedBrand == 'Matchbox',
                    child: CustomTextField(
                      controller: _castingNumber,
                      hint: 'Casting Number (Back)',
                      textCapitalization: TextCapitalization.characters,
                      validation: (String? val) => val!.isEmpty ? 'Casting number is required' : null,
                    ),
                  ),
                  CustomTextField(controller: _price, hint: 'Price', validation: (String? val) => val!.isEmpty ? 'Price is required' : null, isNumber: true),
                  CustomTextField(controller: _description, hint: 'Description', textCapitalization: TextCapitalization.sentences, validation: (String? val) => null, maxLines: 3),
                  Row(
                    children: [
                      Expanded(
                          child: CustomButton(
                              onTap: () {
                                log(selectedBrand.toString());
                                // TODO: clear all fields and remove the loading set state below
                                setState(() {
                                  isLoading = true;
                                });
                              },
                              icon: Icons.cancel,
                              text: 'CLEAR',
                              btnColor: colorRed)),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          icon: Icons.check_circle,
                          text: 'SAVE',
                          btnColor: colorGreen,
                          onTap: connectionStatus != ConnectivityStatus.Offline
                              ? () {
                                  if (imageList.length <= 1) {
                                    setState(() {
                                      isImageError = true;
                                      _animationController.forward();
                                    });
                                  } else if (imageList.length > 1) setState(() => isImageError = false);

                                  if (_formKey.currentState!.validate() && !isImageError) {
                                    log('success');
                                    // TODO: upload to firebase get the image urls store them as a list in the record when updating the details in firebase
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future captureImage([bool isCamera = true]) async {
    if (isCamera) {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100);
      if (image != null) this.setState(() => imageList.add({"name": image.name, "url": image.path}));
    } else {
      List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images != null) this.setState(() => images.forEach((element) => imageList.add({"name": element.name, "url": element.path})));
    }
  }
}
