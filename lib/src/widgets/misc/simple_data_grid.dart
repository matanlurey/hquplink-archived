import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';

class SimpleDataGrid extends StatelessWidget {
  final Map<String, Widget> data;
  final Color oddColor;

  SimpleDataGrid({
    @required this.data,
    this.oddColor,
  })  : assert(data != null),
        assert(data.isNotEmpty);

  @override
  build(context) {
    final theme = Theme.of(context);
    final c = data.entries;
    final results = mapIndexed<Widget, MapEntry<String, Widget>>(c, (i, e) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: i.isOdd ? null : oddColor ?? theme.primaryColor,
        child: Column(
          children: [
            Row(
              children: [
                Text(e.key),
                e.value,
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )
          ],
        ),
      );
    }).toList();
    return Column(
      children: results,
    );
  }
}
