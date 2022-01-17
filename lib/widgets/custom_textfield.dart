import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final bool isSecure;
  bool isPassword;
  final bool isEmail;
  final bool isNumber;
  final bool isMultiline;
  final bool isEnabled;
  final TextEditingController controller;
  final String hint;
  final maxLength;
  final maxLines;
  final validation;
  final IconData icon;
  final onChanged;
  final autofill;
  final onEditingComplete;

  CustomTextField({
    this.isPassword = false,
    this.isEmail = false,
    this.isNumber = false,
    this.isMultiline = false,
    this.isSecure = false,
    this.isEnabled = true,
    @required this.controller,
    @required this.hint,
    this.maxLength,
    this.maxLines = 1,
    @required this.validation,
    this.icon,
    this.onChanged,
    this.autofill,
    this.onEditingComplete,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: widget.onEditingComplete,
      autofillHints: widget.autofill,
      enabled: widget.isEnabled,
      cursorColor: Theme.of(context).colorScheme.secondary,
      maxLines: widget.maxLines,
      validator: widget.validation,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      controller: widget.controller,
      obscureText: widget.isPassword,
      keyboardType: widget.isEmail ? TextInputType.emailAddress : (widget.isNumber ? TextInputType.number : (widget.isMultiline ? TextInputType.multiline : TextInputType.text)),
      style: TextStyle(fontFamily: fontMedium),
      decoration: InputDecoration(
        filled: true,
        labelText: widget.hint,
        border: InputBorder.none,
        suffixIcon: widget.isSecure
            ? GestureDetector(
                onTap: () {
                  setState(() => widget.isPassword = !widget.isPassword);
                },
                child: Icon(widget.isPassword ? Icons.visibility : Icons.visibility_off))
            : null,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        hintText: widget.hint,
        contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        hintStyle: TextStyle(fontFamily: fontRegular),
        errorStyle: TextStyle(fontFamily: fontMedium, fontSize: textSizeSmall),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: hintColor, width: 1.0)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1)),
      ),
    );
  }
}
