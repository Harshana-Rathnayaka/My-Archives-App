import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../components/theme.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../providers/google_signin_provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Drawer(
        child: SafeArea(
          child: Material(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              children: [
                Container(
                  color: Theme.of(context).canvasColor,
                  margin: EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        radius: 26,
                        child: CachedNetworkImage(
                          imageUrl: user.photoURL,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          width: 50,
                          height: 50,
                          placeholder: (context, url) =>
                              new Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error, size: 26),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName,
                                style: TextStyle(
                                    fontFamily: fontRegular,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(
                                    fontFamily: fontRegular,
                                    fontSize: textSizeSmall),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      FlutterSwitch(
                        duration: Duration(milliseconds: 800),
                        width: 50.0,
                        height: 24.0,
                        toggleSize: 20.0,
                        value: notifier.isDark,
                        borderRadius: 14.0,
                        padding: 1.0,
                        activeToggleColor: activeToggleColor,
                        inactiveToggleColor: inactiveToggleColor,
                        activeSwitchBorder:
                            Border.all(color: activeSwitchBorder, width: 1.0),
                        inactiveSwitchBorder:
                            Border.all(color: inactiveSwitchBorder, width: 1.0),
                        activeColor: activeColor,
                        inactiveColor: colorWhite,
                        activeIcon:
                            Icon(Icons.nightlight_round, color: activeIcon),
                        inactiveIcon: Icon(Icons.wb_sunny, color: inactiveIcon),
                        onToggle: (value) {
                          notifier.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1.0),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text('FAQs'),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('How to use'),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                ),
                SizedBox(height: 24),
                Divider(thickness: 1.0),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
