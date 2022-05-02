import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_ui/pinball_ui.dart';

void main() {
  group('PinballButton', () {
    testWidgets('renders the given text and responds to taps', (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PinballButton(
                text: 'test',
                onTap: () {
                  wasTapped = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('test'));
      expect(wasTapped, isTrue);
    });
  });
}
