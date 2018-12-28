import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
import 'package:hquplink/patterns.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

/// Renders, and optionally, provides edits for a specific [Army].
class ViewArmyPage extends StatefulWidget {
  final Army army;
  final void Function(Army) onUpdate;

  const ViewArmyPage({
    @required this.army,
    @required this.onUpdate,
  }) : assert(army != null);

  @override
  createState() => _ArmyViewState();
}

class _ArmyViewState extends Mutex<Army, ViewArmyPage> {
  @override
  initMutex() => widget.army;

  @override
  onUpdate() => widget.onUpdate(value);

  @override
  build(context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          FactionSliverHeader<_ViewArmyMenuOptions>(
            title: value.name,
            faction: value.faction,
            menu: const [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Details'),
                ),
                value: _ViewArmyMenuOptions.edit,
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Army'),
                ),
                value: _ViewArmyMenuOptions.delete,
              ),
            ],
            onMenuPressed: (option) {
              switch (option) {
                case _ViewArmyMenuOptions.delete:
                  return _deleteArmy(context);
                case _ViewArmyMenuOptions.edit:
                  return _editArmy(context);
              }
            },
            bottom: _ViewArmyHeader(army: value),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: _buildList,
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Color.lerp(
          factionColor(value.faction),
          Colors.white,
          0.25,
        ),
        foregroundColor: Colors.white,
        onPressed: _addUnit,
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    // TODO: Use CustomScrollView or ReorderableListView when shrinkWrap'd.
    // (https://github.com/flutter/flutter/issues/25789)
    return ListView(
      children: mapIndexed<Widget, ArmyUnit>(value.units, (index, unit) {
        return Card(
          child: Dismissible(
            key: Key(unit.id),
            background: const DismissBackground(),
            child: _PreviewUnitTile(
              unit: unit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) {
                    return ViewUnitPage(
                      unit: unit,
                      onUpdate: (newUnit) {
                        setValue(
                            value.rebuild((b) => b.units[index] = newUnit));
                      },
                    );
                  }),
                );
              },
            ),
            onDismissed: (_) => _deleteUnit(context, unit),
            direction: DismissDirection.startToEnd,
          ),
        );
      }).toList(),
      padding: const EdgeInsets.all(0),
      primary: true,
      shrinkWrap: true,
    );
  }

  void _addUnit() {}

  void _editArmy(BuildContext context) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute<Army>(
        builder: (_) {
          return CreateArmyDialog(
            initialData: value.toBuilder(),
            editExisting: true,
          );
        },
        fullscreenDialog: true,
      ),
    );
    if (edited != null) {
      setValue(edited);
    }
  }

  void _deleteUnit(BuildContext context, ArmyUnit unit) {
    final catalog = getCatalog(context);
    final details = catalog.lookupUnit(unit.unit);
    setValue(
      value.rebuild((b) => b.units.remove(unit)),
      notifyRevert: context,
      describeRevert: (_) => 'Removed ${details.name}',
    );
  }

  void _deleteArmy(BuildContext context) async {
    if (value.units.isNotEmpty || value.commands.isNotEmpty) {
      if (!await showConfirmDialog(
        context: context,
        discardText: 'Delete',
        title: 'Delete ${value.name}?',
      )) {
        return;
      }
    }
    widget.onUpdate(null);
    Navigator.pop(context);
  }
}

class _ViewArmyHeader extends StatelessWidget {
  final Army army;

  const _ViewArmyHeader({
    @required this.army,
  });

  @override
  build(context) {
    final catalog = getCatalog(context);
    final theme = Theme.of(context);
    final sumPoints = catalog.sumArmyPoints(army);
    final withinMax = army.maxPoints == null || sumPoints <= army.maxPoints;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Row(
        children: [
          Text('${army.units.length} Activations'),
          Row(
            children: [
              Text('${catalog.sumArmyPoints(army)}'),
              Text(
                ' / ${army.maxPoints ?? '∞'}',
                style: withinMax ? null : TextStyle(color: theme.errorColor),
              ),
              const Text(' Points'),
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

/// Options for the popup menu for the [ViewArmyPage].
enum _ViewArmyMenuOptions {
  edit,
  delete,
}

class _PreviewUnitTile extends StatelessWidget {
  final ArmyUnit unit;
  final void Function() onPressed;

  _PreviewUnitTile({
    @required this.unit,
    this.onPressed,
  })  : assert(unit != null),
        super(key: Key(unit.id));

  @override
  build(context) {
    final catalog = getCatalog(context);
    final details = catalog.lookupUnit(unit.unit);
    return ListTile(
      title: Text(details.name),
      subtitle: details.subTitle != null ? Text(details.subTitle) : null,
      leading: UnitAvatar(details),
      trailing: _SumPointsBox(
        points: catalog.sumUnitPoints(unit),
        color: factionColor(details.faction),
      ),
      onTap: onPressed,
    );
  }
}

class _SumPointsBox extends StatelessWidget {
  final Color color;
  final int points;

  const _SumPointsBox({
    @required this.points,
    this.color,
  }) : assert(points != null);

  @override
  build(context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: color ?? theme.primaryColor,
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: ConstrainedBox(
        child: Text(
          '$points',
          style: theme.primaryTextTheme.caption.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        constraints: const BoxConstraints(minWidth: 30),
      ),
    );
  }
}
