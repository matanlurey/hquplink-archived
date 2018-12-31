import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hquplink/models.dart';
import 'package:hquplink/widgets.dart';

import '../common.dart';

// TODO: Figure out why images are still not rendering in this test.
void main() {
  final findWidget = find.byType(DefenseSideIcon);

  void _test(DefenseDiceSide side) {
    testWidgets('$side', (tester) async {
      final assetBundle = await tester.runAsync(
        () => DiskAssetBundle.loadGlob(['assets/dice/defense/*.png']),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.grey,
            body: DefaultAssetBundle(
              bundle: assetBundle,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: DefenseSideIcon(
                    side: side,
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        findWidget,
        matchesGoldenFile(
          'goldens/defense_dice_side/${side.toString().split('.').last}.png',
        ),
      );
    });
  }

  DefenseDiceSide.values.forEach(_test);
}
