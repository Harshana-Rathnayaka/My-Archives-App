import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../services/movie_service.dart';
import '../utils/helper_methods.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_delete_dialog.dart';
import '../widgets/custom_no_records.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/helper_widgets.dart';
import '../widgets/search.dart';

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
  List<Map<String, dynamic>> movieToRemove;

  TextEditingController _movieNameController = TextEditingController();
  TextEditingController _movieYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: 'Watched Movies'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: Search(itemList: movies));
              }),
        ],
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
            if (snapshot.hasData && !snapshot.data.exists) {
              return Center(
                child: Text(
                  'Document does not exist',
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
                            color: Theme.of(context).chipTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          "${movies.length.toString()} Movies",
                          style: TextStyle(
                              fontFamily: fontMedium,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 24),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButton(
                            underline: SizedBox(),
                            elevation: 10,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontFamily: fontRegular,
                                  fontWeight: FontWeight.bold,
                                ),
                            value: dropDownValue,
                            isDense: true,
                            items: dropDownList
                                .map((value) => DropdownMenuItem(
                                      child: Text(
                                        value,
                                        style:
                                            TextStyle(fontFamily: fontRegular),
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
                  child: movies != null && movies.length > 0
                      ? Scrollbar(
                          isAlwaysShown: true,
                          showTrackOnHover: true,
                          thickness: 6.0,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            itemCount: movies.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: Key(movies[index].toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.delete_forever,
                                      color: colorWhite, size: 35),
                                  decoration: BoxDecoration(
                                    color: colorRed,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  print(movies[index].toString());

                                  var movieName =
                                      movies[index]['name'].toString();
                                  var movieYear =
                                      movies[index]['year'].toString();

                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomDeleteDialog(
                                          item: movieName,
                                          onPressed: () {
                                            WatchedMovieService(uid: user.uid)
                                                .deleteWatchedMovie(data: [
                                              {
                                                'name': movieName,
                                                'year': movieYear
                                              }
                                            ]).then((value) {
                                              showToast(
                                                  msg:
                                                      '$movieName ($movieYear) deleted successfully!',
                                                  backGroundColor: colorGreen);
                                              clear();
                                            }).onError((error, stackTrace) {
                                              print(error);
                                              print(stackTrace);
                                              showToast(
                                                  msg:
                                                      'Something went wrong! \n Error - $error',
                                                  backGroundColor: colorRed);
                                            });
                                            finish(context);
                                          }));
                                  return false;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.5)),
                                  ),
                                  child: ListTile(
                                    enableFeedback: true,
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
                                    trailing: IconButton(
                                      enableFeedback: true,
                                      iconSize: 20,
                                      tooltip: 'Edit movie details',
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        print(movies[index]);

                                        var movieName = movies[index]['name'];
                                        var movieYear =
                                            movies[index]['year'].toString();

                                        _movieNameController.text = movieName;
                                        _movieYearController.text = movieYear;

                                        movieToRemove = [
                                          {'name': movieName, 'year': movieYear}
                                        ];
                                        showMovieDialog(context, type: 'Update')
                                            .whenComplete(() {
                                          clear();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ))
                      : CustomNoRecords(text: 'No data available'),
                ),
              ],
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showMovieDialog(context, type: 'Add').whenComplete(() {
            clear();
          });
        },
      ),
    ));
  }

  Future showMovieDialog(BuildContext context, {@required String type}) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, StateSetter setState) => CustomDialog(
                heading: type == 'Add'
                    ? 'Add to your watched movies'
                    : 'Edit movie details',
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
                          isMovieExist = checkifExist(val.trim().toLowerCase());
                          print(isMovieExist);
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
                    // values from the text controllers to add to the db (preparing this list for easy access)
                    var newMovieDetails = [
                      {
                        'name': _movieNameController.text,
                        'year': _movieYearController.text
                      }
                    ];
                    if (type == 'Add') {
                      // if the dialog is to add movies
                      WatchedMovieService(uid: user.uid)
                          .addWatchedMovies(movieToAdd: newMovieDetails)
                          .then((value) {
                        showToast(
                            msg:
                                '${_movieNameController.text} was added successfully!',
                            backGroundColor: colorGreen);
                        clear();
                      }).onError((error, stackTrace) {
                        print(error);
                        print(stackTrace);
                        showToast(
                            msg: 'Something went wrong! \n Error - $error',
                            backGroundColor: colorRed);
                      });
                    } else {
                      // if the dialog is to update movies
                      WatchedMovieService(uid: user.uid)
                          .updateWatchedMovieDetails(
                              movieToRemove: movieToRemove,
                              movieToUpdate: newMovieDetails)
                          .then((value) {
                        showToast(
                            msg: 'Movie details were updated successfully!',
                            backGroundColor: colorGreen);
                        clear();
                        finish(context);
                      }).onError((error, stackTrace) {
                        print(error);
                        print(stackTrace);
                        showToast(
                            msg: 'Something went wrong! \n Error - $error',
                            backGroundColor: colorRed);
                      });
                    }
                  }
                },
              ),
            ));
  }

  // resetting the forms and other values
  clear() {
    print(movies);
    isMovieExist = false;
    yearCheck = '';
    _movieNameController.clear();
    _movieYearController.clear();
    movies.forEach((element) {
      movieNames.add(element['name'].toLowerCase());
    });
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
