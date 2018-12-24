import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

import 'pages/army_list_page.dart';

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

  @override
  build(_) {
    return MaterialApp(
      title: 'HQ Uplink',
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HQ Uplink'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final catalog = getCatalog(context);
                    final army = await Navigator.push(
                      context,
                      MaterialPageRoute<Army>(
                        builder: (_) {
                          return _CreateArmyDialog(
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
                  },
                );
              },
            )
          ],
        ),
        body: ArmyListPage(
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

class _CreateArmyDialog extends StatefulWidget {
  final ArmyBuilder initialData;

  const _CreateArmyDialog({
    @required this.initialData,
  }) : assert(initialData != null);

  @override
  createState() {
    return _CreateArmyDialogState(army: initialData);
  }
}

class _CreateArmyDialogState extends State<_CreateArmyDialog> {
  ArmyBuilder army;

  _CreateArmyDialogState({
    @required this.army,
  }) : assert(army != null);

  /// Whether the form is complete.
  bool get isComplete {
    return army.name?.isNotEmpty == true && army.faction != null;
  }

  @override
  build(context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Army'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: isComplete
                ? () {
                    Navigator.pop(context, army.build());
                  }
                : null,
          ),
        ],
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TextField(
              autofocus: true,
              maxLength: 64,
              decoration: const InputDecoration(
                labelText: 'Army Name',
                filled: true,
              ),
              style: theme.textTheme.headline,
              onChanged: (name) {
                setState(() {
                  army.name = name;
                });
              },
            ),
            Column(
              children: [
                Text(
                  'Faction',
                  style: theme.textTheme.subhead,
                ),
                RadioListTile<Faction>(
                  groupValue: army.faction,
                  value: Faction.darkSide,
                  title: const Text('Galactic Empire'),
                  secondary: const FactionIcon(
                    Faction.darkSide,
                    height: 24,
                  ),
                  onChanged: (value) {
                    setState(() {
                      army.faction = value;
                    });
                  },
                ),
                RadioListTile<Faction>(
                  groupValue: army.faction,
                  value: Faction.lightSide,
                  title: const Text('Rebel Alliance'),
                  secondary: const FactionIcon(
                    Faction.lightSide,
                    height: 24,
                  ),
                  onChanged: (value) {
                    setState(() {
                      army.faction = value;
                    });
                  },
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Column(
              children: [
                Text(
                  'Maximum Points',
                  style: theme.textTheme.subhead,
                ),
                RadioListTile<int>(
                  groupValue: army.maxPoints,
                  value: 0,
                  title: const Text('Unlimited (∞)'),
                  onChanged: (value) {
                    setState(() {
                      army.maxPoints = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  groupValue: army.maxPoints,
                  value: 800,
                  title: const Text('Standard (800)'),
                  onChanged: (value) {
                    setState(() {
                      army.maxPoints = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  groupValue: army.maxPoints,
                  value: 1600,
                  title: const Text('Grand (1600)'),
                  onChanged: (value) {
                    setState(() {
                      army.maxPoints = value;
                    });
                  },
                ),
                Slider(
                  min: 0,
                  max: 1600,
                  label: '${army.maxPoints} Points',
                  value: army.maxPoints.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      army.maxPoints = value.toInt();
                    });
                  },
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ].map((widget) {
            return Container(
              child: widget,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(vertical: 8),
            );
          }).toList(),
        ),
      ),
    );
  }
}
