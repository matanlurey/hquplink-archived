import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/patterns.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

/// Renders a collection of [Army]s.
class ListArmiesPage extends StatefulWidget {
  /// Initial list of armies to display.
  ///
  /// Subsequent updates, if any, are handled locally and via [onUpdate].
  final BuiltList<Army> initialArmies;

  /// Optional; if defined, allows [initialArmies] to be edited.
  final void Function(BuiltList<Army>) onUpdate;

  ListArmiesPage({
    @required this.initialArmies,
    this.onUpdate,
  })  : assert(initialArmies != null),
        super(key: ValueKey(initialArmies));

  @override
  createState() => _ListArmiesState();
}

class _ListArmiesState extends Mutex<BuiltList<Army>, ListArmiesPage> {
  @override
  initMutex() => widget.initialArmies;

  @override
  onUpdate() => widget.onUpdate(value);

  void _dismissArmy(Army army, {BuildContext allowUndo}) {
    setValue(
      value.rebuild((b) => b.remove(army)),
      notifyRevert: allowUndo,
      describeRevert: (_) => 'Removed ${army.name}',
    );
  }

  void _reorderArmy(int oldIndex, int newIndex) {
    setValue(
      value.rebuild((b) {
        return b.insert(
          newIndex > oldIndex ? newIndex - 1 : newIndex,
          b.removeAt(oldIndex),
        );
      }),
    );
  }

  @override
  build(context) {
    final children = value.map((army) {
      return _ArmyListTile(
        army: army,
        onDismiss: () => _dismissArmy(army, allowUndo: context),
        onPressed: () => _viewArmyDetails(army),
      );
    }).toList();
    final listView = ReorderableListView(
      children: children,
      onReorder: _reorderArmy,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: listView,
    );
  }

  void _viewArmyDetails(Army oldArmy) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return ViewArmyPage(
            army: oldArmy,
            onUpdate: (newArmy) {
              if (newArmy == null) {
                return _dismissArmy(oldArmy);
              }
              setValue(
                value.rebuild((b) {
                  final index = value.indexOf(oldArmy);
                  assert(index != -1);
                  // ignore: parameter_assignments
                  oldArmy = newArmy;
                  b[index] = newArmy;
                }),
              );
            },
          );
        },
      ),
    );
  }
}

class _ArmyListTile extends StatelessWidget {
  /// Army to display details of.
  final Army army;

  /// Optional; if defined, allows dismissal.
  final void Function() onDismiss;

  /// Optional; if defined, allows pressing.
  final void Function() onPressed;

  _ArmyListTile({
    @required this.army,
    this.onDismiss,
    this.onPressed,
  })  : assert(army != null),
        super(key: Key(army.id));

  @override
  build(context) {
    final catalog = getCatalog(context);
    final units = army.units.map((u) => catalog.lookupUnit(u.unit));
    final sorted = units.toList()..sort((a, b) => a.points.compareTo(b.points));
    final leaders = sorted.reversed.take(3).toList();
    final sumPoints = catalog.sumArmyPoints(army);
    final maxPoints = '${army.maxPoints ?? '∞'} Points';
    Widget tile = ListTile(
      title: Text(army.name),
      subtitle: Text('$sumPoints / $maxPoints'),
      leading: FactionIcon(
        army.faction,
        height: 24,
      ),
      trailing: _UnitLeaderPreview(leaders: leaders),
      onTap: onPressed,
    );
    if (onDismiss != null) {
      tile = Dismissible(
        key: Key(army.id),
        background: const DismissBackground(),
        child: tile,
        onDismissed: (_) => onDismiss(),
        direction: DismissDirection.startToEnd,
      );
    }
    return Card(child: tile);
  }
}

class _UnitLeaderPreview extends StatelessWidget {
  final List<Unit> leaders;

  const _UnitLeaderPreview({
    @required this.leaders,
  }) : assert(leaders != null);

  @override
  build(_) {
    return SizedBox(
      width: 100,
      height: 40,
      child: Stack(
        children: mapIndexed<Widget, Unit>(leaders.reversed, (i, u) {
          return Positioned(
            child: DecoratedBox(
              child: UnitAvatar(u),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                    color: Colors.black.withOpacity(0.7),
                  ),
                ],
                shape: BoxShape.circle,
              ),
            ),
            right: (i * 30).toDouble(),
          );
        }).toList(),
      ),
    );
  }
}
