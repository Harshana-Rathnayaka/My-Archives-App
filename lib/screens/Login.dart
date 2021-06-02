import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_archive/constants/fonts.dart';
import 'package:my_archive/constants/images.dart';
import 'package:my_archive/providers/google_signin_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static var tag = "/Login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
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
                provider.login();
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 16.0,
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
