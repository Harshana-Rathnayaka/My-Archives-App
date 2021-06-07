import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_archive/services/tv_series_service.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../utils/helper_methods.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_delete_dialog.dart';
import '../widgets/custom_no_records.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/helper_widgets.dart';
import '../widgets/search.dart';

class WatchedTvSeries extends StatefulWidget {
  static var tag = "/WatchedTvSeries";

  @override
  _WatchedTvSeriesState createState() => _WatchedTvSeriesState();
}

class _WatchedTvSeriesState extends State<WatchedTvSeries> {
  final user = FirebaseAuth.instance.currentUser;
  List tvSeries = [];
  List tvSeriesNames = [];
  List dropDownList = [
    'Sort by Year ASC',
    'Sort by Year DESC',
    'Sort by Name ASC',
    'Sort by Name DESC'
  ];
  bool isTvSeriesExist = false;
  String yearCheck;
  String dropDownValue = 'Sort by Name ASC';
  List<Map<String, dynamic>> tvSeriesToRemove;

  TextEditingController _tvSeriesNameController = TextEditingController();
  TextEditingController _tvSeriesYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: 'Watched Tv Series'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: Search(itemList: tvSeries));
              }),
        ],
      ),
      body: StreamBuilder(
          stream: WatchedTvSeriesService(uid: user.uid)
              .getWatchedTvSeriesCollection(),
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

            tvSeries = snapshot.data['tvSeries'];

            sortList();

            // getting the tv series list to another variable to check if it exists
            tvSeries.forEach((element) {
              tvSeriesNames.add(element['name'].toLowerCase());
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
                          "${tvSeries.length.toString()} Tv Series",
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
                  child: tvSeries != null && tvSeries.length > 0
                      ? Scrollbar(
                          isAlwaysShown: true,
                          showTrackOnHover: true,
                          thickness: 6.0,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            itemCount: tvSeries.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: Key(tvSeries[index].toString()),
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
                                  print(tvSeries[index].toString());

                                  var tvSeriesName =
                                      tvSeries[index]['name'].toString();
                                  var tvSeriesYear =
                                      tvSeries[index]['year'].toString();

                                  showDialog(
                                      context: context,
                                      builder: (context) => CustomDeleteDialog(
                                          item: tvSeriesName,
                                          onPressed: () {
                                            WatchedTvSeriesService(
                                                    uid: user.uid)
                                                .deleteWatchedTvSeries(data: [
                                              {
                                                'name': tvSeriesName,
                                                'year': tvSeriesYear
                                              }
                                            ]).then((value) {
                                              showToast(
                                                  msg:
                                                      '$tvSeriesName ($tvSeriesYear) deleted successfully!',
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
                                          color: Colors.grey, width: 0.5),
                                    ),
                                  ),
                                  child: ListTile(
                                    enableFeedback: true,
                                    title: Text(
                                      tvSeries[index]['name'],
                                      style: TextStyle(
                                          fontFamily: fontRegular,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      tvSeries[index]['year'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: fontMedium),
                                    ),
                                    trailing: IconButton(
                                      enableFeedback: true,
                                      iconSize: 20,
                                      tooltip: 'Edit tv series details',
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        print(tvSeries[index]);

                                        var tvSeriesName =
                                            tvSeries[index]['name'];
                                        var tvSeriesYear =
                                            tvSeries[index]['year'].toString();

                                        _tvSeriesNameController.text =
                                            tvSeriesName;
                                        _tvSeriesYearController.text =
                                            tvSeriesYear;

                                        tvSeriesToRemove = [
                                          {
                                            'name': tvSeriesName,
                                            'year': tvSeriesYear
                                          }
                                        ];
                                        showTvSeriesDialog(context,
                                                type: 'Update')
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
          showTvSeriesDialog(context, type: 'Add').whenComplete(() {
            clear();
          });
        },
      ),
    ));
  }

  Future showTvSeriesDialog(BuildContext context, {@required String type}) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, StateSetter setState) => CustomDialog(
                heading: type == 'Add'
                    ? 'Add to your watched tv series'
                    : 'Edit tv series details',
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _tvSeriesNameController,
                      hint: 'Name of the Tv Series',
                      icon: Icons.live_tv_outlined,
                      validation: (val) {
                        String newVal = val.trim();
                        if (newVal.isEmpty) {
                          return 'Name of the Tv Series is required';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          isTvSeriesExist =
                              checkifExist(val.trim().toLowerCase());
                          print(isTvSeriesExist);
                        });
                      },
                    ),
                    isTvSeriesExist
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'This tv series already exists in the database',
                              style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontFamily: fontMedium,
                                  fontSize: textSizeSmall),
                            ),
                          )
                        : Container(),
                    SizedBox(height: 16.0),
                    CustomTextField(
                      controller: _tvSeriesYearController,
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
                  if (!isTvSeriesExist) {
                    // values from the text controllers to add to the db (preparing this list for easy access)
                    var newTvSeriesDetails = [
                      {
                        'name': _tvSeriesNameController.text,
                        'year': _tvSeriesYearController.text
                      }
                    ];
                    if (type == 'Add') {
                      // if the dialog is to add tv series
                      WatchedTvSeriesService(uid: user.uid)
                          .addWatchedTvSeries(tvSeriesToAdd: newTvSeriesDetails)
                          .then((value) {
                        showToast(
                            msg:
                                '${_tvSeriesNameController.text} was added successfully!',
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
                      // if the dialog is to update tv series
                      WatchedTvSeriesService(uid: user.uid)
                          .updateTvSeriesDetails(
                              tvSeriesToRemove: tvSeriesToRemove,
                              tvSeriesToUpdate: newTvSeriesDetails)
                          .then((value) {
                        showToast(
                            msg: 'Tv Series details were updated successfully!',
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
    print(tvSeries);
    isTvSeriesExist = false;
    yearCheck = '';
    _tvSeriesNameController.clear();
    _tvSeriesYearController.clear();
    tvSeries.forEach((element) {
      tvSeriesNames.add(element['name'].toLowerCase());
    });
  }

  // sorting the list
  List sortList() {
    if (dropDownValue == 'Sort by Year ASC') {
      tvSeries.sort((a, b) {
        return a['year'].toString().compareTo(b['year'].toString());
      });
    } else if (dropDownValue == 'Sort by Year DESC') {
      tvSeries.sort((a, b) {
        return b['year'].toString().compareTo(a['year'].toString());
      });
    } else if (dropDownValue == 'Sort by Name DESC') {
      tvSeries.sort((a, b) {
        return b['name'].compareTo(a['name']);
      });
    } else {
      tvSeries.sort((a, b) {
        return a['name'].compareTo(b['name']);
      });
    }

    return tvSeries;
  }

  // check if the tv series exists
  bool checkifExist(val) {
    if (tvSeriesNames.contains(val)) {
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
