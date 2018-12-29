import 'package:flutter/material.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';

class CreateArmyDialog extends StatefulWidget {
  final bool editExisting;
  final ArmyBuilder initialData;

  const CreateArmyDialog({
    this.editExisting = false,
    @required this.initialData,
  }) : assert(initialData != null);

  @override
  createState() {
    return _CreateArmyDialogState(army: initialData);
  }
}

class _CreateArmyDialogState extends State<CreateArmyDialog> {
  ArmyBuilder army;
  TextEditingController editName;

  _CreateArmyDialogState({
    @required this.army,
  }) : assert(army != null);

  @override
  initState() {
    editName = TextEditingController(text: army.name);
    super.initState();
  }

  /// Whether the form is complete.
  bool get isComplete {
    return army.name?.isNotEmpty == true && army.faction != null;
  }

  @override
  build(context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.editExisting
            ? const Text('Edit Army')
            : const Text('Create Army'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed:
                isComplete ? () => Navigator.pop(context, army.build()) : null,
          ),
        ],
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TextField(
              autofocus: true,
              controller: editName,
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
                  divisions: 1600 ~/ 50,
                  value: army.maxPoints.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      army.maxPoints = value.toInt();
                    });
                  },
                  activeColor: theme.accentColor,
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
