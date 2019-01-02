import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/widgets.dart';

class KeywordsList extends StatelessWidget {
  final BuiltMap<Keyword, String> keywords;

  const KeywordsList({
    @required this.keywords,
  }) : assert(keywords != null);

  @override
  build(context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      children: ListTile.divideTiles(
        context: context,
        tiles: keywords.entries.map(
          (e) {
            return ListTile(
              title: Text(
                '${formatKeyword(e.key)} ${e.value}',
              ),
              contentPadding: const EdgeInsets.all(0),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ViewKeywordPage.navigateTo(context, e.key);
              },
            );
          },
        ),
      ).toList(),
    );
  }
}
