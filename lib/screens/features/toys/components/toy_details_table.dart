import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/fonts.dart';
import '../../../../models/toy.dart';

class ToyDetailsTable extends StatelessWidget {
  final Toy toy;

  const ToyDetailsTable({Key? key, required this.toy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      columnWidths: {0: FractionColumnWidth(0.4), 1: FractionColumnWidth(0.6)},
      children: [
        TableRow(children: [
          Text('Brand', style: TextStyle(fontFamily: fontMedium)),
          Text(': ${toy.brand}', style: TextStyle(fontFamily: fontSemiBold)),
        ]),
        TableRow(children: [
          Text('Type', style: TextStyle(fontFamily: fontMedium)),
          Text(toy.type != null ? ': ${toy.type}' : ': N/A', style: TextStyle(fontFamily: fontSemiBold)),
        ]),
        TableRow(children: [
          Text('Year', style: TextStyle(fontFamily: fontMedium)),
          Text(': ${toy.year}', style: TextStyle(fontFamily: fontSemiBold)),
        ]),
        TableRow(children: [
          toy.modelNumber != null ? Text('Model Number', style: TextStyle(fontFamily: fontMedium)) : Container(),
          toy.modelNumber != null ? Text(': ${toy.modelNumber}', style: TextStyle(fontFamily: fontSemiBold)) : Container(),
        ]),
        TableRow(children: [
          toy.castingNumber != null ? Text('Casting Number', style: TextStyle(fontFamily: fontMedium)) : Container(),
          toy.castingNumber != null ? Text(': ${toy.castingNumber}', style: TextStyle(fontFamily: fontSemiBold)) : Container(),
        ]),
        TableRow(children: [
          Text('Price', style: TextStyle(fontFamily: fontMedium)),
          Text(': ${NumberFormat.currency(name: '', locale: 'en_GB').format(double.parse(toy.price))} LKR', style: TextStyle(fontFamily: fontSemiBold))
        ]),
        TableRow(children: [
          Text('Description', style: TextStyle(fontFamily: fontMedium)),
          Text(toy.description != null ? ': ${toy.description}' : ': N/A', style: TextStyle(fontFamily: fontSemiBold)),
        ]),
      ],
    );
  }
}
