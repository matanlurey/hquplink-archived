import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/pages.dart';
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
          ArmySliverHeader<_ArmyMenuAction>(
            army: army.build(),
            menu: const [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Details'),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Army'),
                ),
              ),
            ],
            onMenuPressed: (option) {
              switch (option) {
                case _ArmyMenuAction.delete:
                  return _deleteArmy();
                case _ArmyMenuAction.edit:
                  return _editArmy(context);
              }
            },
          ),
          const SliverList(
            delegate: SliverChildListDelegate([]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: factionColor(army.faction),
        foregroundColor: Colors.white,
        onPressed: _addUnit,
      ),
    );
  }

  void _addUnit() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return UnitCreatePage(
            army: army.build(),
          );
        },
      ),
    );
  }

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
  }

  void _deleteArmy() {
    widget.onUpdate(null);
    Navigator.pop(context);
  }
}

enum _ArmyMenuAction {
  edit,
  delete,
}
