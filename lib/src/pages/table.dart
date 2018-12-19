import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

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
        return Row(
          children: [
            _UnitCard(unit),
          ],
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: cards.toList()),
    );
  }
}

class _UnitCard extends StatefulWidget {
  final ArmyUnit unit;

  const _UnitCard(this.unit);

  @override
  createState() => _UnitCardState();
}

// TODO: Animate out when removed.
class _UnitCardState extends State<_UnitCard> {
  var isExpanded = false;

  @override
  build(context) {
    var subtitle = '${widget.unit.unit.points} Points';
    if (widget.unit.upgrades.isNotEmpty) {
      subtitle = '$subtitle (${widget.unit.upgrades.length} Upgrades)';
    }
    final children = <Widget>[
      ListTile(
        leading: UnitAvatar(widget.unit.unit),
        title: Text(widget.unit.unit.name),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
      ),
    ];
    // TODO: Animate open/closed.
    if (isExpanded) {
      final table = services.Table.of(context);
      children.add(ButtonBar(
        children: [
          FlatButton(
            child: const Text('REMOVE'),
            onPressed: () {
              table.removeUnit(widget.unit);
            },
          ),
        ],
      ));
    }
    return Expanded(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
