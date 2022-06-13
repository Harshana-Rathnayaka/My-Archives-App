import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../utils/helper_methods.dart';

class CustomDatePicker extends StatefulWidget {
  final bool isEnabled;
  final TextEditingController controller;
  final String hint;
  final validation;
  final IconData? icon;
  final onChanged;

  CustomDatePicker({
    Key? key,
    this.isEnabled = true,
    required this.controller,
    required this.hint,
    required this.validation,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final FocusNode _focusNode = FocusNode();
  DateTime selectedDate = DateTime.now();
  late String formattedDate;

  @override
  void initState() {
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        enabled: widget.isEnabled,
        readOnly: true,
        showCursor: false,
        cursorColor: Theme.of(context).colorScheme.secondary,
        validator: widget.validation,
        onChanged: widget.onChanged,
        controller: widget.controller,
        style: TextStyle(fontFamily: fontMedium),
        decoration: InputDecoration(
          filled: true,
          labelText: widget.hint,
          border: InputBorder.none,
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          hintText: widget.hint,
          contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          hintStyle: TextStyle(fontFamily: fontRegular),
          errorStyle: TextStyle(fontFamily: fontMedium, fontSize: textSizeSmall),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: hintColor, width: 1.0)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
          suffixIcon: GestureDetector(
            child: Icon(Icons.calendar_month),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Select the year"),
                  content: Container(
                    width: 300,
                    height: 300,
                    child: YearPicker(
                      firstDate: DateTime(1960),
                      lastDate: DateTime(DateTime.now().year + 2),
                      initialDate: DateTime.now(),
                      selectedDate: selectedDate,
                      onChanged: (DateTime dateTime) {
                        setState(() => widget.controller.text = dateTime.year.toString());
                        finish(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    // return TextFormField(
    //   focusNode: _focusNode,
    //   validator: widget.validation,
    //   enabled: widget.isEnabled,
    //   controller: widget.controller,
    //   readOnly: true,
    //   // style: TextStyle(fontFamily: fontMedium, color: theme.isDark ? dmTextColorPrimary : lmTextColorPrimary),
    //   decoration: InputDecoration(
    //     labelText: widget.hint,
    //     suffixIcon: GestureDetector(
    //       // child: Icon(widget.isTime ? Icons.alarm : Icons.date_range, color: colorPrimary),
    //       onTap: () => showDatePicker(
    //         context: context,
    //         initialDate: selectedDate ?? DateTime.now(),
    //         firstDate: widget.firstDate ?? DateTime.now(),
    //         lastDate: widget.lastDate ?? DateTime.now().add(const Duration(days: 90)),
    //         // builder: (BuildContext context, Widget? child) {
    //         //   return Theme(
    //         //     child: child!,
    //         //     data: theme.isDark
    //         //         ? Theme.of(context).copyWith(colorScheme: const ColorScheme.dark(primary: colorPrimary))
    //         //         : Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)),
    //         //   );
    //         // },
    //       ).then((value) {
    //         if (value == null) return; // do nothing if user cancels

    //         setState(() {
    //           selectedDate = value;
    //           formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
    //           widget.controller.text = formattedDate;
    //         });
    //       }),
    //     ),
    //     isDense: widget.isDense,
    //     prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
    //     hintText: widget.hint,
    //     contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
    //     hintStyle: TextStyle(fontFamily: fontRegular),
    //     errorStyle: TextStyle(fontFamily: fontMedium, fontSize: textSizeSmall),
    //     disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: hintColor, width: 1.0)),
    //     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
    //     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
    //     errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
    //     focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
    //   ),
    // );
  }
}
