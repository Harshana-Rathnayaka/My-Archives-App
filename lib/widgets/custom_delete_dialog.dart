import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../components/connectivity_status.dart';
import '../components/theme.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../utils/helper_methods.dart';

class CustomDeleteDialog extends StatefulWidget {
  final Function onPressed;

  CustomDeleteDialog({
    @required this.onPressed,
  });
  @override
  _CustomDeleteDialogState createState() => _CustomDeleteDialogState();
}

class _CustomDeleteDialogState extends State<CustomDeleteDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Dialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal[800],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                ),
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.only(bottom: 20.0),
                alignment: Alignment.center,
                child: Text(
                  'Delete item',
                  style: TextStyle(
                      fontFamily: fontMedium,
                      fontWeight: FontWeight.bold,
                      fontSize: textSizeMedium,
                      color: colorWhite),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'Are you sure you want to delete this item? This action is irreversible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: fontMedium),
                  )),
              SizedBox(height: 12),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: CircularProgressIndicator(),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  connectionStatus != ConnectivityStatus.Offline
                                      ? () {
                                          finish(context);
                                        }
                                      : null,
                              icon: Icon(Icons.cancel),
                              label: Text(
                                'NO',
                                style: TextStyle(
                                    fontFamily: fontMedium,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(colorRed)),
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                                  connectionStatus != ConnectivityStatus.Offline
                                      ? () {
                                          widget.onPressed();
                                        }
                                      : null,
                              icon: Icon(Icons.check_circle),
                              label: Text(
                                'YES',
                                style: TextStyle(
                                    fontFamily: fontMedium,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    connectionStatus !=
                                            ConnectivityStatus.Offline
                                        ? colorGreen
                                        : Colors.grey),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
              connectionStatus != ConnectivityStatus.Offline
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: Text(
                          'No internet connection',
                          style: TextStyle(fontFamily: fontMedium),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
