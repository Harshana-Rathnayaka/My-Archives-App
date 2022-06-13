import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

class CustomDropDownField extends StatefulWidget {
  final String hint;
  final List<DropdownMenuItem<String>>? items;
  final String? selectedValue;
  final bool isFilled;
  final bool isEnabled;
  final bool isDense;
  final bool isExpanded;
  final String? Function(String?)? validation;
  final Function(String?)? onChanged;
  final void Function()? onTap;

  const CustomDropDownField({
    Key? key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.validation,
    required this.onChanged,
    this.isFilled = true,
    this.isEnabled = true,
    this.isDense = true,
    this.isExpanded = true,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DropdownButtonFormField(
        value: widget.selectedValue,
        items: widget.items,
        validator: widget.validation,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        isExpanded: widget.isExpanded,
        isDense: widget.isDense,
        decoration: InputDecoration(
          enabled: widget.isEnabled,
          filled: widget.isFilled,
          labelText: widget.hint,
          hintText: widget.hint,
          errorMaxLines: 2,
          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          border: InputBorder.none,
          errorStyle: TextStyle(fontFamily: fontMedium, fontSize: textSizeSmall),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: hintColor, width: 1.0)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
        ),
      ),
    );
  }
}
