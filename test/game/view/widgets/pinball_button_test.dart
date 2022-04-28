import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../../helpers/helpers.dart';

void main() {
  const buttonText = 'this is the button text';

  testWidgets('displays button', (tester) async {
    await tester.pumpApp(
      const Material(
        child: PinballButton(
          child: Text(buttonText),
        ),
      ),
    );

    expect(find.text(buttonText), findsOneWidget);
  });

  testWidgets('on tap calls onPressed callback', (tester) async {
    var isTapped = false;

    await tester.pumpApp(
      Material(
        child: PinballButton(
          child: const Text(buttonText),
          onPressed: () {
            isTapped = true;
          },
        ),
      ),
    );
    await tester.tap(find.text(buttonText));

    expect(isTapped, isTrue);
  });
}
