import 'package:flutter/material.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage();

  @override
  build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    return ListView(
      children: ListTile.divideTiles(
        color: dividerColor,
        tiles: [
          ListTile(
            leading: const Icon(Icons.list),
            trailing: const Icon(Icons.arrow_right),
            title: const Text('Units'),
            onTap: () {
              // TODO: Implement.
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            trailing: const Icon(Icons.arrow_right),
            title: const Text('Weapons'),
            onTap: () {
              // TODO: Implement.
            },
          ),
        ],
      ).toList(),
    );
  }
}
