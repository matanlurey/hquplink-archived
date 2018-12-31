import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';

void main() {
  final findWidget = find.byType(AttackDiceIcon);

  void _test(AttackDice dice) {
    testWidgets('${dice.name}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.grey,
            body: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: AttackDiceIcon(
                  dice: dice,
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        findWidget,
        matchesGoldenFile('goldens/attack_dice_icon/${dice.name}.png'),
      );
    });
  }

  AttackDice.values.forEach(_test);
}
