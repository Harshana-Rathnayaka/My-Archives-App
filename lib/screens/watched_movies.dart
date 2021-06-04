import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/fonts.dart';
import '../widgets/helper_widgets.dart';

class WatchedMovies extends StatefulWidget {
  static var tag = "/WatchedMovies";

  @override
  _WatchedMoviesState createState() => _WatchedMoviesState();
}

class _WatchedMoviesState extends State<WatchedMovies> {
  final user = FirebaseAuth.instance.currentUser;
  List movies = [];
  List dropDownList = [
    'Sort by Year ASC',
    'Sort by Year DESC',
    'Sort by Name ASC',
    'Sort by Name DESC'
  ];
  String dropDownValue = 'Sort by Name ASC';

  @override
  Widget build(BuildContext context) {
    final _stream = FirebaseFirestore.instance
        .collection('watchedMovies')
        .doc(user.uid)
        .snapshots();

    return SafeArea(
      child: (Scaffold(
        appBar: AppBar(
          title: AppBarTitle(title: 'Watched Movies'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong. \n Error - ${snapshot.error}',
                    style: TextStyle(
                        fontFamily: fontRegular, fontWeight: FontWeight.bold),
                  ),
                );
              }
              movies = snapshot.data['movies'];

              sortList();

              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).chipTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "${movies.length.toString()} movies",
                            style: TextStyle(
                                fontFamily: fontMedium,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 24),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 1),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton(
                              underline: SizedBox(),
                              elevation: 10,
                              style: TextStyle(
                                fontFamily: fontRegular,
                                fontWeight: FontWeight.bold,
                              ),
                              value: dropDownValue,
                              isDense: true,
                              items: dropDownList
                                  .map((value) => DropdownMenuItem(
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontFamily: fontRegular),
                                        ),
                                        value: value,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                print('inside on change');
                                setState(() {
                                  dropDownValue = value;
                                  print('set change: $value');
                                });
                              },
                              isExpanded: true,
                              hint: Text(
                                'Sort by',
                                style: TextStyle(fontFamily: fontRegular),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      isAlwaysShown: true,
                      showTrackOnHover: true,
                      thickness: 6.0,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        itemCount: movies.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.5)),
                            ),
                            child: ListTile(
                              title: Text(
                                movies[index]['name'],
                                style: TextStyle(
                                    fontFamily: fontRegular,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                movies[index]['year'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontMedium),
                              ),
                              trailing: Icon(Icons.edit, size: 20),
                              enableFeedback: true,
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: null,
        // ),
      )),
    );
  }

  // sorting the list
  List sortList() {
    if (dropDownValue == 'Sort by Year ASC') {
      movies.sort((a, b) {
        return a['year'].toString().compareTo(b['year'].toString());
      });
    } else if (dropDownValue == 'Sort by Year DESC') {
      movies.sort((a, b) {
        return b['year'].toString().compareTo(a['year'].toString());
      });
    } else if (dropDownValue == 'Sort by Name DESC') {
      movies.sort((a, b) {
        return b['name'].compareTo(a['name']);
      });
    } else {
      movies.sort((a, b) {
        return a['name'].compareTo(b['name']);
      });
    }

    return movies;
  }
}
