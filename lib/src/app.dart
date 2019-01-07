import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

/// TODO: Make configurable.
const _isDevMode = !const bool.fromEnvironment('dart.vm.product');

/// Represents the application shell for HQ Uplink.
class AppShell extends StatefulWidget {
  static ThemeData _buildDefaultTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey.shade800,
      accentColor: Colors.blueGrey.shade400,
    );
  }

  final String appVersion;
  final Roster initialRoster;
  final void Function(Roster) onRosterUpdated;

  const AppShell({
    @required this.appVersion,
    @required this.initialRoster,
    @required this.onRosterUpdated,
  })  : assert(appVersion != null),
        assert(initialRoster != null);

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

  void _updateRoster(void Function(RosterBuilder) update) {
    setState(() {
      roster = roster.rebuild(update);
      widget.onRosterUpdated(roster);
    });
  }

  void _addNewArmy(BuildContext context) async {
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
      _updateRoster((b) => b.armies.add(army));
    }
  }

  @override
  build(context) {
    final auth = getAuth(context);
    Widget userAccountHeader;
    if (auth.isSignedIn) {
      userAccountHeader = Builder(
        builder: (context) {
          return UserAccountsDrawerHeader(
            currentAccountPicture: InkWell(
              child: CircleAvatar(
                backgroundImage: NetworkImage(auth.current.photoUrl),
              ),
              onTap: () async {
                if (await showConfirmDialog(
                      context: context,
                      title: 'Sign Out',
                      discardText: 'Sign Out',
                    ) ==
                    true) {
                  await auth.signOut();
                  setState(() {});
                }
              },
            ),
            accountEmail: Text(auth.current.emailAddress),
            accountName: Text(auth.current.displayName),
          );
        },
      );
    } else {
      userAccountHeader = UserAccountsDrawerHeader(
        accountEmail: Center(
          child: FlatButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign in with Google'),
            onPressed: auth.isEnabled
                ? () async {
                    await auth.signIn();
                    setState(() {
                      // Notify that 'auth' may have changed.
                    });
                  }
                : null,
          ),
        ),
        accountName: Container(),
      );
    }
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
              onPressed: () => _addNewArmy(context),
            );
          },
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              userAccountHeader,
              _isDevMode
                  ? Builder(
                      builder: (context) {
                        return ListTile(
                          title: const Text('Developer'),
                          leading: const Icon(Icons.lock_open),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return const DeveloperPage();
                                },
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Container(),
              Builder(
                builder: (context) {
                  return ListTile(
                    leading: const Icon(Icons.casino),
                    title: const Text('Dice Simulator'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return const DiceSimulatorPage();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              AboutListTile(
                icon: const Icon(Icons.info),
                applicationIcon: const Icon(Icons.info, color: Colors.white),
                applicationVersion: widget.appVersion,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: ListArmiesPage(
            initialArmies: roster.armies,
            onUpdate: (armies) {
              _updateRoster((b) => b.armies = armies.toBuilder());
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
