import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../components/enums.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../constants/images.dart';
import '../providers/google_signin_provider.dart';
import '../utils/helper_methods.dart';

class Login extends StatefulWidget {
  static var tag = "/Login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hey there,', style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.w500, fontSize: textSizeLarge)),
              Text('Welcome to Your Archives', style: TextStyle(fontFamily: fontMedium, fontWeight: FontWeight.bold, fontSize: textSizeXXLarge)),
              SizedBox(height: 20),
              Align(child: Text('Login to you account to continue', style: TextStyle(fontFamily: fontSemiBold, fontSize: textSizeSMedium))),
              SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

                  connectionStatus != ConnectivityStatus.Offline
                      ? provider.googleLogin()
                      : ScaffoldMessenger.of(context).showSnackBar(customSnackBar(icon: Icons.cloud_off, iconColor: colorRed, text: 'No internet connection!'));
                },
                child: Card(
                  color: connectionStatus != ConnectivityStatus.Offline ? Theme.of(context).cardColor : Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  elevation: connectionStatus != ConnectivityStatus.Offline ? 16.0 : 0.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(google, width: 30.0, height: 30.0),
                        SizedBox(width: 20.0),
                        Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: fontRegular, fontSize: textSizeLargeMedium)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
