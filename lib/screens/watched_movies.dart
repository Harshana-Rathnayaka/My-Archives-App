import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../services/movie_service.dart';
import '../utils/helper_methods.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/helper_widgets.dart';

class WatchedMovies extends StatefulWidget {
  static var tag = "/WatchedMovies";

  @override
  _WatchedMoviesState createState() => _WatchedMoviesState();
}

class _WatchedMoviesState extends State<WatchedMovies> {
  final user = FirebaseAuth.instance.currentUser;
  List movies = [];
  List movieNames = [];
  List dropDownList = [
    'Sort by Year ASC',
    'Sort by Year DESC',
    'Sort by Name ASC',
    'Sort by Name DESC'
  ];
  bool isMovieExist = false;
  String yearCheck;
  String dropDownValue = 'Sort by Name ASC';

  TextEditingController _movieNameController = TextEditingController();
  TextEditingController _movieYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (Scaffold(
        appBar: AppBar(
          title: AppBarTitle(title: 'Watched Movies'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: WatchedMovieService(uid: user.uid).getWatchedMoviesStream(),
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

              // getting the movie list to another variable to check if it exists
              movies.forEach((element) {
                movieNames.add(element['name'].toLowerCase());
              });

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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                      builder: (context, StateSetter setState) => CustomDialog(
                        heading: 'Add to your watched movies',
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _movieNameController,
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
                                setState(() {
                                  isMovieExist =
                                      checkifExist(val.trim().toLowerCase());
                                });
                              },
                            ),
                            isMovieExist
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'This movie already exists in the database',
                                      style: TextStyle(
                                          color: Theme.of(context).errorColor,
                                          fontFamily: fontMedium,
                                          fontSize: textSizeSmall),
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _movieYearController,
                              hint: 'Year',
                              icon: Icons.date_range,
                              isNumber: true,
                              maxLength: 4,
                              validation: (val) {
                                String newVal = val.trim();
                                if (newVal.isEmpty) {
                                  return 'Year is required';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                if (val.trim().isNotEmpty) {
                                  setState(() {
                                    yearCheck = checkYear(val.trim());
                                  });
                                } else if (val.trim().isEmpty) {
                                  setState(() {
                                    yearCheck = null;
                                  });
                                }
                              },
                            ),
                            yearCheck != null
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      yearCheck,
                                      style: TextStyle(
                                          color: Theme.of(context).errorColor,
                                          fontFamily: fontRegular,
                                          fontSize: textSizeSmall),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        onSave: () {
                          if (!isMovieExist) {
                            WatchedMovieService(uid: user.uid)
                                .addWatchedMovies(data: [
                              {
                                'name': _movieNameController.text,
                                'year': _movieYearController.text
                              }
                            ]).then((value) {
                              showToast(
                                  msg:
                                      '${_movieNameController.text} was added successfully!',
                                  backGroundColor: colorGreen);
                              clear();
                            }).onError((error, stackTrace) {
                              print(error);
                              print(stackTrace);
                              showToast(
                                  msg: 'Something went wrong! Error - $error',
                                  backGroundColor: colorRed);
                            });
                          }
                        },
                      ),
                    )).whenComplete(() {
              clear();
            });
          },
        ),
      )),
    );
  }

  // resetting the forms and other values
  clear() {
    isMovieExist = false;
    yearCheck = '';
    _movieNameController.clear();
    _movieYearController.clear();
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

  // check if the movie exists
  bool checkifExist(val) {
    if (movieNames.contains(val)) {
      return true;
    }
    return false;
  }

  // check if the year is correct and between range
  String checkYear(value) {
    int year = int.parse(value);

    if (year < 1900) {
      return 'Year cannot be less than 1900';
    } else if (year > 2200) {
      return 'Year cannot be greater than 2200';
    }
    return null;
  }
}
