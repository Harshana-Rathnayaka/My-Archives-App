import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_archive/components/theme.dart';
import 'package:my_archive/constants/fonts.dart';
import 'package:my_archive/providers/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: SafeArea(
        child: Material(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
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
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName,
                              style: TextStyle(
                                  fontFamily: fontRegular,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            user.email,
                            style: TextStyle(
                                fontFamily: fontRegular,
                                fontSize: textSizeSmall),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
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
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => SwitchListTile(
                  secondary: Icon(
                      notifier.isDark ? Icons.nights_stay : Icons.wb_sunny,
                      color: notifier.isDark ? Colors.yellow : null),
                  title: Text(notifier.isDark ? "Light Mode" : "Dark Mode"),
                  value: notifier.isDark,
                  onChanged: (value) {
                    notifier.toggleTheme();
                  },
                ),
              ),
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
