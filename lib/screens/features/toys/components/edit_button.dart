import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(24), bottomLeft: Radius.circular(12)),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }
}
