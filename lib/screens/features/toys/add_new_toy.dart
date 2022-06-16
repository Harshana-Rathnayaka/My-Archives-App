import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

import '../../../components/connectivity_status.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/custom_dropdown_field.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/helper_widgets.dart';

class AddNewToy extends StatefulWidget {
  static var tag = "/AddNewToy";

  const AddNewToy({Key? key}) : super(key: key);

  @override
  State<AddNewToy> createState() => _AddNewToyState();
}

class _AddNewToyState extends State<AddNewToy> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _year = TextEditingController();
  MaskedTextController _cardNumber = MaskedTextController(mask: '000/000');
  TextEditingController _serialNumber = TextEditingController();
  TextEditingController _carName = TextEditingController();
  TextEditingController _description = TextEditingController();
  MoneyMaskedTextController _price = MoneyMaskedTextController(initialValue: 0.00, decimalSeparator: '.', leftSymbol: 'Rs. ', thousandSeparator: ',');

  late Size size;
  late List? images;
  List<String> brands = ['Hot Wheels', 'Matchbox', 'Tarmac Works', 'Mini GT'];
  List<String> type = ['Basic (Mainline)', 'Premium'];
  String? selectedBrand;
  String? selectedType;
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    _year.dispose();
    _cardNumber.dispose();
    _serialNumber.dispose();
    _carName.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(title: 'Add New Toy'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.width / 2.5,
                  child: GridView.builder(
                      itemCount: 1,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 0, mainAxisExtent: size.width - 20),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 0.5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt), iconSize: 30),
                              GestureDetector(child: Text('or \n select from gallery', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontFamily: fontMedium))),
                            ],
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
                CustomTextField(controller: _cardNumber, hint: 'Card Number (Front)', validation: (String? val) => val!.isEmpty ? 'Card number is required' : null, isNumber: true),
                CustomTextField(controller: _serialNumber, hint: 'Serial Number (Back)', validation: (String? val) => val!.isEmpty ? 'Serial number is required' : null),
                CustomTextField(controller: _carName, hint: 'Car Name', validation: (String? val) => val!.isEmpty ? 'Car name is required' : null),
                CustomTextField(controller: _price, hint: 'Price', validation: (String? val) => null, isNumber: true),
                CustomTextField(controller: _description, hint: 'Description', validation: (String? val) => null, maxLines: 3),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                            onTap: () {
                              log(selectedBrand.toString());
                            },
                            icon: Icons.cancel,
                            text: 'CANCEL',
                            btnColor: colorRed)),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        icon: Icons.check_circle,
                        text: 'SAVE',
                        btnColor: colorGreen,
                        onTap: connectionStatus != ConnectivityStatus.Offline
                            ? () {
                                if (_formKey.currentState!.validate()) {}
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
    );
  }
}
