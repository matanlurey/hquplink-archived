import 'package:flutter/material.dart';

/// A vertical panel including a [title] and a [body].
class DataPanel extends StatelessWidget {
  final Widget title;
  final Widget body;

  const DataPanel({
    @required this.title,
    @required this.body,
  });

  @override
  build(context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      child: DefaultTextStyle(
                        child: title,
                        style: theme.textTheme.title,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                    ),
                    body,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
