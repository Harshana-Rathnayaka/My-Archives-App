import 'package:flutter/material.dart';

import '../../../components/enums.dart';
import '../../../constants/fonts.dart';
import '../../../utils/helper_methods.dart';
import '../../../widgets/custom_no_records.dart';

class ToySearch extends SearchDelegate {
  final List itemList;
  SortBy? searchBy;
  ToySearch({required this.itemList, this.searchBy = SortBy.Name});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () async => showSearchOptions(context), icon: Icon(Icons.tune)),
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
            searchBy = SortBy.Name;
          } else {
            query = '';
            searchBy = SortBy.Name;
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => throw UnimplementedError();

  @override
  Widget buildSuggestions(BuildContext context) {
    // checking the typed value and building suggestions based on it
    // query is the typed value (comes from search delegate)
    final suggestions = itemList.where((e) {
      final itemLower;
      final queryLower;

      if (searchBy == SortBy.Name) {
        itemLower = e.modelName.toLowerCase();
        queryLower = query.toLowerCase();
        return itemLower.startsWith(queryLower);
      } else {
        itemLower = e.brand.toLowerCase();
        queryLower = query.toLowerCase();
        return itemLower.startsWith(queryLower);
      }
    }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List suggestions) {
    return suggestions.length > 0
        ? ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              // to highlight the typed query in the suggested results list
              final queryText;
              final remainingText;

              if (searchBy == SortBy.Name) {
                queryText = suggestion.modelName.substring(0, query.length);
                remainingText = suggestion.modelName.substring(query.length);
              } else {
                queryText = suggestion.brand.substring(0, query.length);
                remainingText = suggestion.brand.substring(query.length);
              }

              return ListTile(
                title: RichText(
                  text: TextSpan(
                      text: searchBy == SortBy.Name ? queryText : suggestion.modelName,
                      style: DefaultTextStyle.of(context).style.copyWith(fontFamily: fontMedium, fontWeight: FontWeight.bold),
                      children: searchBy == SortBy.Name
                          ? [TextSpan(text: searchBy == SortBy.Name ? remainingText : suggestion.modelName, style: DefaultTextStyle.of(context).style.copyWith(fontFamily: fontMedium))]
                          : null),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: searchBy == SortBy.Brand ? queryText : suggestion.brand,
                          style: DefaultTextStyle.of(context).style.copyWith(fontFamily: fontMedium, fontWeight: FontWeight.bold, fontSize: textSizeSmall, color: Colors.grey.shade500),
                          children: searchBy == SortBy.Brand
                              ? [
                                  TextSpan(
                                      text: searchBy == SortBy.Brand ? remainingText : suggestion.brand,
                                      style: DefaultTextStyle.of(context).style.copyWith(fontFamily: fontMedium, fontSize: textSizeSmall, color: Colors.grey.shade500))
                                ]
                              : null),
                    ),
                    // Text('${suggestion.brand} ${suggestion.type ?? ''}', style: TextStyle(fontFamily: fontRegular, fontWeight: FontWeight.bold, fontSize: textSizeSmall)),
                    Text(suggestion.year, style: TextStyle(fontFamily: fontRegular, fontWeight: FontWeight.bold, fontSize: textSizeSmall, color: Colors.grey.shade500)),
                  ],
                ),
              );
            })
        : CustomNoRecords(text: 'No records found');
  }

  // search options dialog
  showSearchOptions(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Search by', style: TextStyle(fontFamily: fontMedium, fontSize: textSizeLargeMedium)),
              content: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 6,
                      minVerticalPadding: 0,
                      minLeadingWidth: 0,
                      visualDensity: VisualDensity(vertical: -3, horizontal: -2),
                      title: Text(enumToString(SortBy.Name), style: TextStyle(fontFamily: fontRegular, fontWeight: FontWeight.bold)),
                      leading: Radio<SortBy>(
                        value: SortBy.Name,
                        groupValue: searchBy,
                        onChanged: (SortBy? value) => setState(() => searchBy = value),
                        visualDensity: VisualDensity(horizontal: -4),
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 6,
                      minVerticalPadding: 0,
                      minLeadingWidth: 0,
                      visualDensity: VisualDensity(vertical: -3, horizontal: -2),
                      title: Text(enumToString(SortBy.Brand), style: TextStyle(fontFamily: fontRegular, fontWeight: FontWeight.bold)),
                      leading: Radio<SortBy>(
                        value: SortBy.Brand,
                        groupValue: searchBy,
                        onChanged: (SortBy? value) => setState(() => searchBy = value),
                        visualDensity: VisualDensity(horizontal: -4),
                        activeColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
