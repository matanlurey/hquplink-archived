import 'package:flutter/material.dart';

import 'browse.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  static final _tabs = [
    _HomeTab(
      icon: const Icon(Icons.home),
      title: const Text('Home'),
      build: (_) => const Center(child: Text('Home')),
    ),
    _HomeTab(
      icon: const Icon(Icons.library_books),
      title: const Text('Browse'),
      build: (_) => const BrowsePage(),
    ),
    _HomeTab(
      icon: const Icon(Icons.person),
      title: const Text('Profile'),
      build: (_) => const Center(child: Text('Profile')),
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

class _HomeTab {
  final Widget title;
  final Widget icon;
  final WidgetBuilder build;

  const _HomeTab({
    @required this.title,
    @required this.icon,
    @required this.build,
  });
}
