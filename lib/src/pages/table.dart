import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

import '../services/catalog.dart' as services;
import '../services/table.dart' as services;

import 'browse.dart';
import 'profile.dart';

class TablePage extends StatefulWidget {
  const TablePage();

  @override
  createState() => TableState();
}

class TableState extends State<TablePage> {
  static TableState _currentState;
  static void hackSwitchToTableTab() {
    _currentState.setState(() {
      _currentState._activeTab = _tabs.first;
    });
  }

  static final _tabs = [
    _Tab(
      icon: const Icon(Icons.tablet),
      title: const Text('Table'),
      build: (_) => const _TableView(),
    ),
    _Tab(
      icon: const Icon(Icons.library_books),
      title: const Text('Browse'),
      build: (_) => const BrowsePage(),
    ),
    _Tab(
      icon: const Icon(Icons.person),
      title: const Text('Profile'),
      build: (_) => const ProfilePage(),
    ),
  ];

  var _activeTab = _tabs.first;

  @override
  build(_) {
    _currentState = this;
    return Scaffold(
      appBar: AppBar(
        title: _activeTab.title,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabs.indexOf(_activeTab),
        type: BottomNavigationBarType.fixed,
        items: _tabs.map((t) {
          return BottomNavigationBarItem(
            icon: t.icon,
            title: t.title,
          );
        }).toList(),
        onTap: (index) {
          setState(() => _activeTab = _tabs[index]);
        },
      ),
      body: Builder(
        builder: _activeTab.build,
      ),
    );
  }
}

class _Tab {
  final Widget title;
  final Widget icon;
  final WidgetBuilder build;

  const _Tab({
    @required this.title,
    @required this.icon,
    @required this.build,
  });
}

class _TableView extends StatelessWidget {
  const _TableView();

  @override
  build(context) {
    final table = services.Table.of(context);
    if (table.elements.isEmpty) {
      return const Center(
        child: Text('Empty. Add units to see them here!'),
      );
    }
    final cards = table.mapElements(
      buildUnit: (unit) {
        return _UnitCard(unit);
      },
    );
    return ListView(
      children: cards.toList(),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final ArmyUnit unit;

  const _UnitCard(this.unit);

  @override
  build(context) {
    final theme = Theme.of(context);
    var subtitle = '${unit.unit.points} Points';
    if (unit.upgrades.isNotEmpty) {
      subtitle = '$subtitle (${unit.upgrades.length} Upgrades)';
    }
    return Card(
      child: ExpansionTile(
        leading: UnitAvatar(unit.unit),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(unit.unit.name),
            Text(subtitle, style: theme.textTheme.subtitle),
          ],
        ),
        trailing: PopupMenuButton<_UnitCardOption>(
          icon: const Icon(Icons.more_vert),
          onSelected: (_) {
            services.Table.of(context).removeUnit(unit);
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: _UnitCardOption.removeUnit,
                child: Text('Remove'),
              )
            ];
          },
        ),
      ),
    );
  }
}

enum _UnitCardOption {
  removeUnit,
}
