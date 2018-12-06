import 'package:flutter/widgets.dart';

import 'pages/home.dart';

final homePage = Route._(
  name: '/',
  build: (_) => const HomePage(),
);

final browseUnitsPage = Route._(
  name: '/browse/units',
  build: (_) => const _MissingPage(),
);

final browseWeaponsPage = Route._(
  name: '/browse/weapons',
  build: (_) => const _MissingPage(),
);

class Route {
  final String name;
  final WidgetBuilder build;

  const Route._({
    @required this.name,
    @required this.build,
  });
}

class _MissingPage extends StatelessWidget {
  const _MissingPage();

  @override
  build(_) => const Center(child: Text('404'));
}
