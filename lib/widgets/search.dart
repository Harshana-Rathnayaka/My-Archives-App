import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import 'custom_no_records.dart';

class Search extends SearchDelegate {
  final List itemList;
  Search({required this.itemList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
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
    print(itemList);

    // checking the typed value and building suggestions based on it
    // query is the typed value (comes from search delegate)
    final suggestions = itemList.where((e) {
      final itemLower = e['name'].toLowerCase();
      final queryLower = query.toLowerCase();

      return itemLower.startsWith(queryLower);
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
              final queryText = suggestion['name'].substring(0, query.length);
              final remainingText = suggestion['name'].substring(query.length);

              return ListTile(
                title: RichText(
                  text: TextSpan(
                      text: queryText,
                      style: DefaultTextStyle.of(context).style.copyWith(fontFamily: fontMedium, fontWeight: FontWeight.bold),
                      children: [TextSpan(text: remainingText, style: DefaultTextStyle.of(context).style.copyWith(fontFamily: fontMedium))]),
                ),
                subtitle: Text(suggestion['year'] != null ? suggestion['year'] : 'N/A', style: TextStyle(fontFamily: fontRegular)),
              );
            })
        : CustomNoRecords(text: 'No records found');
  }
}
