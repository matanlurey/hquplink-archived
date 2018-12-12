import 'package:flutter/material.dart';
import 'package:swlegion/database.dart' as database;

import 'routes.dart';
import 'services/auth.dart' as services;
import 'services/catalog.dart' as services;
import 'services/table.dart' as services;

class App extends StatelessWidget {
  static final _builtInCatalog = services.Catalog(
    units: List.unmodifiable(
      database.units.toList()..sort((a, b) => a.name.compareTo(b.name)),
    ),
    upgrades: List.unmodifiable(
      database.upgrades.toList()..sort((a, b) => a.name.compareTo(b.name)),
    ),
    weapons: List.unmodifiable(
      database.weapons.toList()..sort((a, b) => a.name.compareTo(b.name)),
    ),
    version: 1,
  );

  static const _temporaryTable = services.Table(
    version: 1,
  );

  static Widget _provideAuth(Widget child) {
    return StreamBuilder<services.Auth>(
      builder: (context, snapshot) {
        return services.AuthModel(
          auth: snapshot.data,
          child: child,
        );
      },
      initialData: const services.Auth(),
      stream: services.Auth.onUpdate,
    );
  }

  static Widget _provideCatalog(Widget child) {
    return services.CatalogModel(
      catalog: _builtInCatalog,
      child: child,
    );
  }

  static Widget _provideTable(Widget child) {
    return services.TableModel(
      table: _temporaryTable,
      child: child,
    );
  }

  const App();

  @override
  build(_) {
    return _provideAuth(
      _provideTable(
        _provideCatalog(
          MaterialApp(
            title: 'HQ Uplink',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            routes: {
              tablePage.name: tablePage.build,
              browseKeywordsPage.name: browseKeywordsPage.build,
              browseUpgradesPage.name: browseUpgradesPage.build,
              browseUnitsPage.name: browseUnitsPage.build,
              browseWeaponsPage.name: browseWeaponsPage.build,
            },
          ),
        ),
      ),
    );
  }
}
