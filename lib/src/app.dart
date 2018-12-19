import 'dart:async';

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
    version: 'BUILT_IN',
  );

  static const _initialTable = services.Table(
    elements: const [],
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

  static final _loadFromDisk = services.Table.fromDisk();
  static Widget _provideTable(Widget child) {
    final controller = StreamController<services.Table>();
    return FutureBuilder<services.Table>(
      builder: (context, snapshot) {
        return StreamBuilder<services.Table>(
          builder: (context, snapshot) {
            return services.TableModel(
              table: snapshot.data,
              child: child,
              onUpdate: controller.add,
            );
          },
          initialData: _initialTable,
          stream: controller.stream,
        );
      },
      initialData: const services.Table(
        elements: [],
        version: 1,
      ),
      future: _loadFromDisk,
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
            onGenerateRoute: (route) {
              final useRoute = [
                detailsUnitsPage,
                detailsUpgradesPage,
              ].firstWhere(
                (r) => route.name.startsWith(r.name),
                orElse: () => null,
              );
              if (useRoute != null) {
                return MaterialPageRoute<void>(
                  builder: (context) {
                    return useRoute.build(context, route);
                  },
                );
              }
            },
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
