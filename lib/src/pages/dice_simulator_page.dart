import 'package:flutter/material.dart' hide Simulation;
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';

class DiceSimulatorPage extends StatefulWidget {
  final Simulation initialData;

  const DiceSimulatorPage({
    this.initialData,
  });

  @override
  createState() => _DiceSimulatorState();
}

class _DiceSimulatorState extends State<DiceSimulatorPage> {
  Simulation simulation;

  @override
  initState() {
    simulation = widget.initialData ?? Simulation();
    super.initState();
  }

  void _edit(void Function(SimulationBuilder) build) {
    setState(() => simulation = simulation.rebuild(build));
  }

  @override
  build(_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Simulator'),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.assessment),
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (_) {
                        return const SimpleDialog(
                          children: [],
                        );
                      });
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          child: ListView(
            children: [
              Card(
                child: ViewDataCard(
                  title: const Text('Attack'),
                  body: Column(
                    children: simulation.attack.keys.map((type) {
                      final value = simulation.attack[type];
                      return ListTile(
                        title: Text('$value'),
                        leading: SizedBox(
                          width: 12,
                          height: 12,
                          child: AttackDiceIcon(dice: type),
                        ),
                        trailing: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _edit((b) => b.attack[type]++);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: value > 0
                                  ? () => _edit((b) => b.attack[type]--)
                                  : null,
                            ),
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Card(
                child: ViewDataCard(
                  title: const Text('Defense'),
                  body: Row(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 12,
                          height: 12,
                          child: Opacity(
                            child: DefenseDiceIcon(dice: DefenseDice.white),
                            opacity: simulation.defense == DefenseDice.white
                                ? 1.0
                                : 0.3,
                          ),
                        ),
                        onPressed: () {
                          _edit((b) => b.defense = DefenseDice.white);
                        },
                      ),
                      IconButton(
                        icon: SizedBox(
                          width: 12,
                          height: 12,
                          child: Opacity(
                            child: DefenseDiceIcon(dice: DefenseDice.red),
                            opacity: simulation.defense == DefenseDice.red
                                ? 1.0
                                : 0.3,
                          ),
                        ),
                        onPressed: () {
                          _edit((b) => b.defense = DefenseDice.red);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
