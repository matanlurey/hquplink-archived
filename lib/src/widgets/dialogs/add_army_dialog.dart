import 'package:flutter/material.dart';
import 'package:hquplink/widgets.dart';
import 'package:swlegion/swlegion.dart';

/// A full-screen dialog to add a new [Army].
class AddArmyDialog extends StatefulWidget {
  /// Optional initial data for the [Army].
  final ArmyBuilder initialData;

  const AddArmyDialog({
    @required this.initialData,
  });

  @override
  createState() => _AddArmyState(initialData);
}

class _AddArmyState extends State<AddArmyDialog> {
  final ArmyBuilder army;

  _AddArmyState(this.army) : assert(army != null);

  bool get saveRequired => army.name != null && army.faction != null;

  Future<bool> _onWillPop() async {
    if (!saveRequired) {
      return true;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Discard new army?'),
          actions: [
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: const Text('DISCARD'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return result;
  }

  @override
  build(context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(army.name ?? 'New army'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveRequired
                ? () => Navigator.pop(context, army.build())
                : null,
          ),
        ],
      ),
      body: Form(
        onWillPop: _onWillPop,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.bottomLeft,
              child: TextField(
                autofocus: true,
                maxLength: 64,
                decoration: const InputDecoration(
                  labelText: 'Army name',
                  filled: true,
                ),
                style: theme.textTheme.headline,
                onChanged: (name) {
                  setState(() {
                    army.name = name;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.bottomLeft,
              child: DropdownButton<Faction>(
                onChanged: (faction) {
                  setState(() {
                    army.faction = faction;
                  });
                },
                hint: const Text('Select faction'),
                value: army.faction,
                items: const [
                  DropdownMenuItem(
                    child: Text('Rebels'),
                    value: Faction.lightSide,
                  ),
                  DropdownMenuItem(
                    child: Text('Imperials'),
                    value: Faction.darkSide,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  MaxPointsSlider(
                    maxPoints: army.maxPoints ?? 0,
                    onChanged: (newMaxPoints) {
                      if (newMaxPoints == 0) {
                        newMaxPoints = null;
                      }
                      setState(() {
                        army.maxPoints = newMaxPoints;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
