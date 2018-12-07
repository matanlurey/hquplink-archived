import 'package:flutter/widgets.dart';

import 'pages/browse.dart';
import 'pages/home.dart';

final homePage = Route._(
  name: '/',
  build: (_) => const HomePage(),
);

final browseKeywordsPage = Route._(
  name: '/browse/keywords',
  build: (_) => const BrowseKeywordsPage(),
);

final browseUnitsPage = Route._(
  name: '/browse/units',
  build: (_) => const BrowseUnitsPage(),
);

final browseUpgradesPage = Route._(
  name: '/browse/upgrades',
  build: (_) => const BrowseUpgradesPage(),
);

final browseWeaponsPage = Route._(
  name: '/browse/weapons',
  build: (_) => const BrowseWeaponsPage(),
);

class Route {
  final String name;
  final WidgetBuilder build;

  const Route._({
    @required this.name,
    @required this.build,
  });
}
