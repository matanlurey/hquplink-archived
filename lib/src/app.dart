import 'package:flutter/material.dart';
import 'package:swlegion/database.dart' as database;

import 'routes.dart';
import 'services/auth.dart';
import 'services/catalog.dart';

class App extends StatelessWidget {
  static final _builtInCatalog = Catalog(
    units: database.units.toList(),
    weapons: database.weapons.toList(),
    version: 1,
  );

  static Widget _provideAuth(Widget child) {
    return StreamBuilder<Auth>(
      builder: (context, snapshot) {
        return AuthModel(
          auth: snapshot.data,
          child: child,
        );
      },
      initialData: const Auth(),
      stream: Auth.onUpdate,
    );
  }

  static Widget _provideCatalog(Widget child) {
    return CatalogModel(
      catalog: _builtInCatalog,
      child: child,
    );
  }

  const App();

  @override
  build(_) {
    return _provideAuth(
      _provideCatalog(
        MaterialApp(
          title: 'HQ Uplink',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          routes: {
            homePage.name: homePage.build,
            browseKeywordsPage.name: browseKeywordsPage.build,
            browseUpgradesPage.name: browseUpgradesPage.build,
            browseUnitsPage.name: browseUnitsPage.build,
            browseWeaponsPage.name: browseWeaponsPage.build,
          },
        ),
      ),
    );
  }
}
