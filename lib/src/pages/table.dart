import 'package:flutter/material.dart';

import 'browse.dart';
import 'profile.dart';

class TablePage extends StatefulWidget {
  const TablePage();

  @override
  createState() => TableState();
}

class TableState extends State<TablePage> {
  static final _tabs = [
    _Tab(
      icon: const Icon(Icons.tablet),
      title: const Text('Table'),
      build: (_) => const Center(child: Text('Table')),
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
