import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

class ViewKeywordPage extends StatelessWidget {
  static void navigateTo(BuildContext context, Keyword keyword) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ViewKeywordPage(keyword: keyword),
      ),
    );
  }

  final Keyword keyword;

  /// See [navigateTo] for actual in-app use.
  @visibleForTesting
  ViewKeywordPage({
    @required this.keyword,
  })  : assert(keyword != null),
        super(key: Key(keyword.name));

  @override
  build(context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(toTitleCase(keyword.name)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            collapseWhitespace(keyword.description),
            textAlign: TextAlign.center,
            style: theme.textTheme.display1,
          ),
        ),
      ),
    );
  }
}
