import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

/// Renders a collection of [Army]s.
class ListArmiesPage extends StatelessWidget {
  /// Lists of armies to display.
  final BuiltList<Army> armies;

  /// Optional; if defined, allows [armies] to be edited.
  final void Function(BuiltList<Army>) onUpdate;

  const ListArmiesPage({
    @required this.armies,
    this.onUpdate,
  }) : assert(armies != null);

  /// Whether [onUpdate] was provided.
  bool get isEditable => onUpdate != null;

  void _dismissArmy(Army army, {BuildContext allowUndo}) {
    final builder = armies.toBuilder();
    final index = armies.indexOf(army);
    builder.removeAt(index);

    onUpdate(builder.build());

    if (allowUndo != null) {
      _promptUndo(allowUndo, builder, army, index);
    }
  }

  void _promptUndo(
    BuildContext context,
    ListBuilder<Army> list,
    Army army,
    int index,
  ) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${army.name}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            list.insert(index, army);
            onUpdate(list.build());
          },
        ),
      ),
    );
  }

  void _reorderArmy(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      // ignore: parameter_assignments
      newIndex--;
    }
    final builder = armies.toBuilder();
    builder.insert(newIndex, builder.removeAt(oldIndex));
    onUpdate(builder.build());
  }

  @override
  build(context) {
    final children = armies.map((army) {
      return _ArmyListTile(
        army: army,
        onDismiss:
            isEditable ? () => _dismissArmy(army, allowUndo: context) : null,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) {
                return ViewArmyPage(
                  army: army,
                  onUpdate: (newArmy) {
                    if (newArmy == null) {
                      return _dismissArmy(army);
                    }
                    final builder = armies.toBuilder();
                    builder[armies.indexOf(army)] = newArmy;
                    onUpdate(builder.build());
                  },
                );
              },
            ),
          );
        },
      );
    }).toList();
    final listView = isEditable
        ? ReorderableListView(
            children: children,
            onReorder: _reorderArmy,
          )
        : ListView(
            children: children,
          );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: listView,
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
