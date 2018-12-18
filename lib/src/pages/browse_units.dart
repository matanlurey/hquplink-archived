import 'package:flutter/material.dart';

import '../routes.dart';
import '../services/catalog.dart';
import '../widgets/unit_avatar.dart';

class BrowseUnitsPage extends StatelessWidget {
  const BrowseUnitsPage();

  @override
  build(context) {
    final catalog = Catalog.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: catalog.units.map((unit) {
            return ListTile(
              leading: UnitAvatar(unit),
              title: Text(
                unit.name,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: unit.subTitle != null ? Text(unit.subTitle) : null,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '${detailsUnitsPage.name}/${unit.id}',
                );
              },
            );
          }).toList(),
        ).toList(),
      ),
    );
  }
}
