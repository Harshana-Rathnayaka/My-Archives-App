import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_archive/utils/helper_methods.dart';
import 'package:provider/provider.dart';

import 'package:my_archive/components/connectivity_status.dart';
import 'package:my_archive/constants/fonts.dart';
import 'package:my_archive/constants/images.dart';
import 'package:my_archive/providers/google_signin_provider.dart';

class Login extends StatefulWidget {
  static var tag = "/Login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                width: 200.0,
                child: Text(
                  'Welcome To Your Archives',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: fontBold,
                      fontWeight: FontWeight.bold,
                      fontSize: 36),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                if (connectionStatus != ConnectivityStatus.Offline) {
                  provider.login();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(customSnackbar(
                      icon: Icons.cloud_off,
                      iconColor: Colors.red,
                      text: 'No internet connection!'));
                }
              },
              child: Card(
                color: connectionStatus != ConnectivityStatus.Offline
                    ? Theme.of(context).cardColor
                    : Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation:
                    connectionStatus != ConnectivityStatus.Offline ? 16.0 : 0.0,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        google,
                        width: 30.0,
                        height: 30.0,
                      ),
                      SizedBox(width: 20.0),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: fontRegular,
                            fontSize: textSizeLargeMedium),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
