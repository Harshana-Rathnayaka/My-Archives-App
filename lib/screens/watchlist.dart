import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../components/theme.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../services/watchlist_service.dart';
import '../utils/helper_methods.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_no_records.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/helper_widgets.dart';

class Watchlist extends StatefulWidget {
  static var tag = "/Watchlist";

  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  TextEditingController _tvSeriesController = TextEditingController();
  TextEditingController _moviesController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  var _stream;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarTitle(title: 'Watchlist'),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(fontFamily: fontMedium, fontSize: textSizeMedium, letterSpacing: 1.0),
            physics: AlwaysScrollableScrollPhysics(),
            tabs: [Tab(text: 'Movies'), Tab(text: 'Tv Series')],
          ),
        ),
        body: TabBarView(children: [
          FutureBuilder<DocumentSnapshot>(
            future: _stream,
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong", style: TextStyle(fontFamily: fontRegular)));
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return CustomNoRecords(text: 'Document does not exist');
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return data['movies'] != null && data['movies'].length > 0
                    ? RefreshIndicator(
                        onRefresh: () async => getData(),
                        child: ListView.builder(
                          itemCount: data['movies'].length,
                          itemBuilder: (context, index) => ListTile(title: Text(data['movies'][index])),
                        ),
                      )
                    : CustomNoRecords(text: 'No data available');
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
          FutureBuilder<DocumentSnapshot>(
            future: _stream,
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong", style: TextStyle(fontFamily: fontRegular)));
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return CustomNoRecords(text: 'Document does not exist');
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return data['tvSeries'] != null && data['tvSeries'].length > 0
                    ? RefreshIndicator(
                        onRefresh: () async => getData(),
                        child: ListView.builder(
                          itemCount: data['tvSeries'].length,
                          itemBuilder: (context, index) => ListTile(title: Text(data['tvSeries'][index])),
                        ),
                      )
                    : CustomNoRecords(text: 'No data available');
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ]),
        floatingActionButton: Consumer<ThemeNotifier>(
          builder: (context, notifier, child) => SpeedDial(
            child: Icon(Icons.add),
            closedForegroundColor: notifier.isDark! ? colorBlack : colorWhite,
            closedBackgroundColor: Theme.of(context).colorScheme.secondary,
            openForegroundColor: Theme.of(context).colorScheme.secondary,
            openBackgroundColor: notifier.isDark! ? colorBlack : colorWhite,
            labelsStyle: TextStyle(fontFamily: fontRegular, color: colorBlack, fontWeight: FontWeight.bold),
            speedDialChildren: <SpeedDialChild>[
              SpeedDialChild(
                child: Icon(Icons.live_tv),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                label: 'Add a Tv Series',
                closeSpeedDialOnPressed: true,
                onPressed: () {
                  // WatchlistService(uid: user.uid).checkIfExists();
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            heading: 'Add to your wishlist',
                            child: CustomTextField(
                              controller: _tvSeriesController,
                              hint: 'Name of the TV Series',
                              icon: Icons.live_tv_outlined,
                              validation: (val) {
                                String newVal = val.trim();
                                if (newVal.isEmpty) {
                                  return 'Name of the TV Series is required';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                //  check if already exists
                                // WatchlistService(uid: user.uid)
                                //     .checkIfExists()
                                //     .then((value) {
                                //   print('value $value');
                                // });
                              },
                            ),
                            onSave: () {
                              WatchlistService(uid: user!.uid).addToWatchlist(type: 'tvSeries', watchlistData: [_tvSeriesController.text]).then((value) {
                                showToast(msg: 'Record saved successfully!', backGroundColor: colorGreen);
                                _tvSeriesController.clear();
                                getData();
                              }).onError((dynamic error, stackTrace) {
                                print(error);
                                print(stackTrace);
                              });
                            },
                          )).whenComplete(() {
                    _tvSeriesController.clear();
                  });
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.movie),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                label: 'Add a Movie',
                closeSpeedDialOnPressed: true,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            heading: 'Add to your wishlist',
                            child: CustomTextField(
                              controller: _moviesController,
                              hint: 'Name of the Movie',
                              icon: Icons.movie_outlined,
                              validation: (val) {
                                String newVal = val.trim();
                                if (newVal.isEmpty) {
                                  return 'Name of the Movie is required';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                //  check if already exists
                              },
                            ),
                            onSave: () {
                              WatchlistService(uid: user!.uid).addToWatchlist(type: 'movies', watchlistData: [_moviesController.text]).then((value) {
                                showToast(msg: 'Record saved successfully!', backGroundColor: colorGreen);
                                _moviesController.clear();
                                getData();
                              }).onError((dynamic error, stackTrace) {
                                print(error);
                                print(stackTrace);
                                showToast(msg: 'Something went wrong! Error - $error', backGroundColor: colorRed);
                              });
                            },
                          )).whenComplete(() {
                    _moviesController.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

// get data method
  getData() => _stream = FirebaseFirestore.instance.collection('watchlist').doc(user!.uid).get();
}
