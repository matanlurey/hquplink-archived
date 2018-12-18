import 'package:flutter/widgets.dart';

import 'pages/browse.dart' hide BrowseUpgradesPage;
import 'pages/browse_units.dart';
import 'pages/browse_upgrades.dart';
import 'pages/details_units.dart';
import 'pages/details_upgrades.dart';
import 'pages/table.dart';

import 'services/catalog.dart';

final tablePage = StaticRoute._(
  name: '/',
  build: (_) => const TablePage(),
);

final browseKeywordsPage = StaticRoute._(
  name: '/browse/keywords',
  build: (_) => const BrowseKeywordsPage(),
);

final browseUnitsPage = StaticRoute._(
  name: '/browse/units',
  build: (_) => const BrowseUnitsPage(),
);

final browseUpgradesPage = StaticRoute._(
  name: '/browse/upgrades',
  build: (_) => const BrowseUpgradesPage(),
);

final browseWeaponsPage = StaticRoute._(
  name: '/browse/weapons',
  build: (_) => const BrowseWeaponsPage(),
);

class StaticRoute {
  final String name;
  final WidgetBuilder build;

  const StaticRoute._({
    @required this.name,
    @required this.build,
  });
}

final detailsUnitsPage = DynamicRoute._(
  name: '/details/units',
  build: (context, route) {
    final catalog = Catalog.of(context);
    final id = route.name.split('/').last;
    final unit = catalog.units.singleWhere((u) => u.id == id);
    return DetailsUnitPage(unit);
  },
);

final detailsUpgradesPage = DynamicRoute._(
  name: '/details/upgrades',
  build: (context, route) {
    final catalog = Catalog.of(context);
    final id = route.name.split('/').last;
    final upgrade = catalog.upgrades.singleWhere((u) => u.id == id);
    return DetailsUpgradePage(upgrade);
  },
);

class DynamicRoute {
  final String name;
  final Widget Function(BuildContext, RouteSettings) build;

  const DynamicRoute._({
    @required this.name,
    @required this.build,
  });
}
