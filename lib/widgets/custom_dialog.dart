import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/enums.dart';
import '../components/theme.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../utils/helper_methods.dart';

class CustomDialog extends StatefulWidget {
  final String heading;
  final Widget child;
  final Function onSave;

  CustomDialog({
    required this.child,
    required this.onSave,
    required this.heading,
  });
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Dialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: notifier.isDark ? Theme.of(context).primaryColor : Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.only(bottom: 20.0),
                alignment: Alignment.center,
                child: Text(widget.heading, style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.bold, fontSize: textSizeMedium, color: colorWhite)),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Form(key: _formKey, child: widget.child)),
              SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: CircularProgressIndicator(),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                                onPressed: connectionStatus != ConnectivityStatus.Offline ? () => finish(context) : null,
                                icon: Icon(Icons.cancel, color: colorWhite),
                                label: Text('CANCEL', style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.bold, color: colorWhite)),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colorRed))),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: connectionStatus != ConnectivityStatus.Offline
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => _isLoading = true);
                                        widget.onSave();
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  : null,
                              icon: Icon(Icons.check_circle, color: colorWhite),
                              label: Text('SAVE', style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.bold, color: colorWhite)),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(connectionStatus != ConnectivityStatus.Offline ? colorGreen : Colors.grey)),
                            ),
                          )
                        ],
                      ),
              ),
              connectionStatus != ConnectivityStatus.Offline
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(child: Text('No internet connection', style: TextStyle(fontFamily: fontMedium))),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
