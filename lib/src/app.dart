import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

class HQUplinkApp extends StatefulWidget {
  final bool enableDeveloperMode;
  final Roster initialRoster;

  const HQUplinkApp({
    this.enableDeveloperMode = const bool.fromEnvironment('dart.vm.product'),
    @required this.initialRoster,
  })  : assert(enableDeveloperMode != null),
        assert(initialRoster != null);

  @override
  createState() => _HQUplinkAppState(roster: initialRoster);
}

class _HQUplinkAppState extends State<HQUplinkApp> {
  Roster roster;

  _HQUplinkAppState({
    @required this.roster,
  });

  @override
  build(_) {
    return MaterialApp(
      title: 'HQ Uplink',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey.shade800,
        accentColor: Colors.blueGrey.shade400,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('HQ Uplink'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _onAddArmyPressed(context),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final army = roster.armies[index];
                  return Card(
                    child: PreviewArmyTile(
                      army: army,
                      onDismiss: () {
                        _setRoster(
                            roster.rebuild((b) => b.armies.removeAt(index)));
                      },
                      onDeleted: () async {
                        _saveRoster();
                      },
                      onRestore: () {
                        _setRoster(roster
                            .rebuild((b) => b.armies.insert(index, army)));
                      },
                      onUpdate: (updated) {
                        _setRoster(
                            roster.rebuild((b) => b.armies[index] = updated));
                        _saveRoster();
                      },
                    ),
                  );
                },
                itemCount: roster.armies.length,
              ),
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: widget.enableDeveloperMode,
    );
  }

  void _onAddArmyPressed(BuildContext context) async {
    final catalog = getCatalog(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute<Army>(
        builder: (_) => AddArmyDialog(initialData: catalog.createArmy()),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      _setRoster(roster.rebuild((b) => b.armies.insert(0, result)));
      _saveRoster();
    }
  }

  void _setRoster(Roster newRoster) {
    setState(() {
      roster = newRoster;
    });
  }

  void _saveRoster() async {
    await const JsonStorage().saveJson(
      roster,
      Roster.serializer,
      'roster.json',
    );
  }
}
