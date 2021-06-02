import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_archive/constants/fonts.dart';
import 'package:my_archive/constants/images.dart';
import 'package:my_archive/services/UserService.dart';
import 'package:my_archive/widgets/CustomDrawer.dart';

class Dashboard extends StatefulWidget {
  static var tag = "/Dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Archives',
            style: TextStyle(
                fontFamily: fontRegular,
                letterSpacing: 1.0,
                wordSpacing: 1.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Expanded(
              child: GridView(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: [
                  Card(
                    elevation: 10,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            movies,
                            color: Theme.of(context).accentColor,
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'MOVIES',
                            style: TextStyle(
                                letterSpacing: 1.0,
                                fontFamily: fontRegular,
                                fontSize: textSizeLargeMedium),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tv,
                              color: Theme.of(context).accentColor, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'TV SERIES',
                            style: TextStyle(
                                letterSpacing: 1.0,
                                fontFamily: fontRegular,
                                fontSize: textSizeLargeMedium),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark,
                              color: Theme.of(context).accentColor, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'WATCHLIST',
                            style: TextStyle(
                                letterSpacing: 1.0,
                                fontFamily: fontRegular,
                                fontSize: textSizeLargeMedium),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_pin,
                              color: Theme.of(context).accentColor, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'PLACES',
                            style: TextStyle(
                                letterSpacing: 1.0,
                                fontFamily: fontRegular,
                                fontSize: textSizeLargeMedium),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
