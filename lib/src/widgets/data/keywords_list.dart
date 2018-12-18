import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/common.dart';
import 'package:swlegion/swlegion.dart';

class KeywordsList extends StatelessWidget {
  final BuiltMap<Keyword, String> keywords;

  const KeywordsList({
    @required this.keywords,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Column(
      children: keywords.entries.map((word) {
        return Padding(
          child: Column(
            children: [
              Row(
                children: [
                  Text(mapKeyword(word.key, word.value)),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      word.key.description,
                      style: theme.textTheme.caption,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        );
      }).toList(),
    );
  }
}
