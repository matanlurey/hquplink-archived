import 'package:flutter/material.dart';

/// Displays pairs of data (a [title], and a [value]) in a flexible layout.
class DataPair extends StatelessWidget {
  final Widget title;
  final Widget value;

  const DataPair({
    @required this.title,
    @required this.value,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Padding(
      child: Column(
        children: [
          Row(
            children: [
              DefaultTextStyle(
                child: title,
                style: theme.textTheme.body1,
              ),
            ],
          ),
          Row(
            children: [
              DefaultTextStyle(
                child: value,
                style: theme.textTheme.body2,
              ),
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
