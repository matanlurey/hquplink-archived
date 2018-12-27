import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

/// Represents the application shell for HQ Uplink.
class AppShell extends StatefulWidget {
  static ThemeData _buildDefaultTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey.shade800,
      accentColor: Colors.blueGrey.shade400,
    );
  }

  final Roster initialRoster;

  const AppShell({
    @required this.initialRoster,
  }) : assert(initialRoster != null);

  @override
  createState() {
    return _AppShellState(
      roster: initialRoster,
      theme: _buildDefaultTheme(),
    );
  }
}

class _AppShellState extends State<AppShell> {
  /// Army lists to be displayed for the current device or user.
  Roster roster;

  /// Theme used for the application.
  ThemeData theme;

  _AppShellState({
    @required this.roster,
    @required this.theme,
  })  : assert(roster != null),
        assert(theme != null);

  void updateRoster(void Function(RosterBuilder) update) {
    setState(() {
      roster = roster.rebuild(update);
    });
  }

  void addNewArmy(BuildContext context) async {
    final catalog = getCatalog(context);
    final army = await Navigator.push(
      context,
      MaterialPageRoute<Army>(
        builder: (_) {
          return CreateArmyDialog(
            initialData: catalog.createArmy(),
          );
        },
        fullscreenDialog: true,
      ),
    );
    if (army != null) {
      setState(() {
        roster = (roster.toBuilder()..armies.add(army)).build();
      });
    }
  }

  @override
  build(_) {
    return MaterialApp(
      title: 'HQ Uplink',
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HQ Uplink'),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              foregroundColor: Colors.white,
              onPressed: () => addNewArmy(context),
            );
          },
        ),
        body: ListArmiesPage(
          armies: roster.armies,
          onUpdate: (armies) {
            setState(() {
              final builder = roster.toBuilder()..armies.clear();
              builder.armies.addAll(armies);
              roster = builder.build();
            });
          },
        ),
      ),
    );
  }
}
