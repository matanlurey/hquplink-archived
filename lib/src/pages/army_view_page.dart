import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/services.dart';
import 'package:hquplink/widgets.dart';

/// Renders, and optionally, provides edits for a specific [Army].
class ArmyViewPage extends StatefulWidget {
  final Army army;
  final void Function(Army) onUpdate;

  const ArmyViewPage({
    @required this.army,
    this.onUpdate,
  }) : assert(army != null);

  @override
  createState() => _ArmyViewState();
}

class _ArmyViewState extends State<ArmyViewPage> {
  ArmyBuilder army;

  /// Whether [army] should be edited.
  bool get isEditable => widget.onUpdate != null;

  @override
  initState() {
    army = widget.army.toBuilder();
    super.initState();
  }

  @override
  build(context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            backgroundColor: factionColor(army.faction),
            flexibleSpace: FlexibleSpaceBar(
              background: _FactionDecoration(
                faction: army.faction,
              ),
            ),
            actions: [
              PopupMenuButton<_ArmyViewAction>(
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: _ArmyViewAction.editArmy,
                    ),
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: _ArmyViewAction.deleteArmy,
                    ),
                  ];
                },
                onSelected: (action) {
                  switch (action) {
                    case _ArmyViewAction.deleteArmy:
                      return _deleteArmy();
                    case _ArmyViewAction.editArmy:
                      return _editArmy(context);
                  }
                },
              ),
            ],
            title: Text(army.name),
            bottom: PreferredSize(
              preferredSize: const Size(0, 6),
              child: _ArmyHeader(army: army.build()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: factionColor(army.faction),
        foregroundColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  void _addUnit() {}

  void _editArmy(BuildContext context) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute<Army>(
        builder: (_) {
          return CreateArmyDialog(
            initialData: army,
            editExisting: true,
          );
        },
        fullscreenDialog: true,
      ),
    );
    if (edited != null) {
      widget.onUpdate(edited);
      setState(() {
        army = edited.toBuilder();
      });
    }
    Navigator.pop(context);
  }

  void _deleteArmy() {
    widget.onUpdate(null);
    Navigator.pop(context);
  }
}

class _FactionDecoration extends StatelessWidget {
  final Faction faction;

  _FactionDecoration({
    @required this.faction,
  }) : super(key: ValueKey(faction));

  @override
  build(context) {
    return Stack(
      children: [
        Padding(
          child: FactionIcon(
            faction,
            fit: BoxFit.scaleDown,
            color: Color.lerp(
              factionColor(faction),
              Colors.white,
              0.25,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, -0.4),
              colors: <Color>[Color(0x60000000), Color(0x00000000)],
            ),
          ),
        ),
      ],
      fit: StackFit.expand,
    );
  }
}

enum _ArmyViewAction {
  editArmy,
  deleteArmy,
}

class _ArmyHeader extends StatelessWidget {
  final Army army;

  const _ArmyHeader({
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
        horizontal: 8,
        vertical: 4,
      ),
      child: Row(
        children: [
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
          Text('${army.units.length} Activations'),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
