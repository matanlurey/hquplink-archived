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
    final wounds = simulation.expectedWounds();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Simulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          child: ListView(
            children: [
              Card(
                child: ViewDataCard(
                    title: const Text('Results'),
                    subtitle: const Text('Expected at least 50% of the time'),
                    trailing: const Icon(Icons.assessment),
                    body: Column(
                      children: [
                        ListTile(
                          leading: const SizedBox(
                            width: 12,
                            height: 12,
                            child: AttackSideIcon(
                              side: AttackDiceSide.hit,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text('Wounds'),
                          trailing: Text('${wounds.toStringAsPrecision(2)}'),
                        ),
                      ],
                    )),
              ),
              Card(
                child: ViewDataCard(
                  title: const Text('Attacks'),
                  trailing: const SizedBox(
                    width: 20,
                    height: 20,
                    child: AttackSideIcon(
                      side: AttackDiceSide.hit,
                      color: Colors.white,
                    ),
                  ),
                  body: Column(
                    children: [
                      Column(
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
                      Row(
                        children: [
                          const Text('Surge'),
                          IconButton(
                            icon: SizedBox(
                              width: 12,
                              height: 12,
                              child: Opacity(
                                child: const AttackSideIcon(
                                  side: AttackDiceSide.surge,
                                  color: Colors.white,
                                ),
                                opacity:
                                    simulation.attackSurge == null ? 1.0 : 0.3,
                              ),
                            ),
                            onPressed: () {
                              _edit((b) => b.attackSurge = null);
                            },
                          ),
                          IconButton(
                            icon: SizedBox(
                              width: 12,
                              height: 12,
                              child: Opacity(
                                child: const AttackSideIcon(
                                  side: AttackDiceSide.hit,
                                  color: Colors.white,
                                ),
                                opacity:
                                    simulation.attackSurge == AttackSurge.hit
                                        ? 1.0
                                        : 0.3,
                              ),
                            ),
                            onPressed: () {
                              _edit((b) => b.attackSurge = AttackSurge.hit);
                            },
                          ),
                          IconButton(
                            icon: SizedBox(
                              width: 12,
                              height: 12,
                              child: Opacity(
                                child: const AttackSideIcon(
                                  side: AttackDiceSide.criticalHit,
                                  color: Colors.white,
                                ),
                                opacity: simulation.attackSurge ==
                                        AttackSurge.critical
                                    ? 1.0
                                    : 0.3,
                              ),
                            ),
                            onPressed: () {
                              _edit(
                                (b) => b.attackSurge = AttackSurge.critical,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ViewDataCard(
                  title: const Text('Defense'),
                  trailing: const SizedBox(
                    width: 20,
                    height: 20,
                    child: DefenseSideIcon(
                      side: DefenseDiceSide.block,
                      color: Colors.white,
                    ),
                  ),
                  body: Column(
                    children: [
                      Row(
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
                      Row(
                        children: [
                          const Text('Surge'),
                          IconButton(
                            icon: SizedBox(
                              width: 12,
                              height: 12,
                              child: Opacity(
                                child: const DefenseSideIcon(
                                  side: DefenseDiceSide.surge,
                                  color: Colors.white,
                                ),
                                opacity:
                                    !simulation.hasDefenseSurge ? 1.0 : 0.3,
                              ),
                            ),
                            onPressed: () {
                              _edit((b) => b.hasDefenseSurge = false);
                            },
                          ),
                          IconButton(
                            icon: SizedBox(
                              width: 12,
                              height: 12,
                              child: Opacity(
                                child: const DefenseSideIcon(
                                  side: DefenseDiceSide.block,
                                  color: Colors.white,
                                ),
                                opacity: simulation.hasDefenseSurge ? 1.0 : 0.3,
                              ),
                            ),
                            onPressed: () {
                              _edit((b) => b.hasDefenseSurge = true);
                            },
                          ),
                        ],
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
