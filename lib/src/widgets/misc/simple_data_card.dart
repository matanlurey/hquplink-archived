import 'package:flutter/material.dart';

class ViewDataCard extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final Widget body;

  const ViewDataCard({
    @required this.title,
    @required this.body,
    this.subtitle,
    this.leading,
    this.trailing,
  })  : assert(title != null),
        assert(body != null);

  @override
  build(context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          title: DefaultTextStyle(
            style: theme.textTheme.title,
            child: title,
          ),
          leading: leading,
          subtitle: subtitle,
          trailing: trailing,
        ),
        Padding(
          child: body,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
