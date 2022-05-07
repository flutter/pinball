// ignore_for_file: one_member_abstracts

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_ui/gen/gen.dart';
import 'package:pinball_ui/pinball_ui.dart';

extension _WidgetTesterX on WidgetTester {
  Future<void> pumpButton({
    required PinballDpadDirection direction,
    required VoidCallback onTap,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PinballDpadButton(
            direction: direction,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

extension _CommonFindersX on CommonFinders {
  Finder byImagePath(String path) {
    return find.byWidgetPredicate(
      (widget) {
        if (widget is Image) {
          final image = widget.image;

          if (image is AssetImage) {
            return image.keyName == path;
          }
          return false;
        }

        return false;
      },
    );
  }
}

abstract class _VoidCallbackStubBase {
  void onCall();
}

class _VoidCallbackStub extends Mock implements _VoidCallbackStubBase {}

void main() {
  group('PinballDpadButton', () {
    testWidgets('can be tapped', (tester) async {
      final stub = _VoidCallbackStub();
      await tester.pumpButton(
        direction: PinballDpadDirection.up,
        onTap: stub.onCall,
      );

      await tester.tap(find.byType(Image));

      verify(stub.onCall).called(1);
    });

    group('up', () {
      testWidgets('renders the correct image', (tester) async {
        await tester.pumpButton(
          direction: PinballDpadDirection.up,
          onTap: () {},
        );

        expect(
          find.byImagePath(Assets.images.button.dpadUp.keyName),
          findsOneWidget,
        );
      });
    });

    group('down', () {
      testWidgets('renders the correct image', (tester) async {
        await tester.pumpButton(
          direction: PinballDpadDirection.down,
          onTap: () {},
        );

        expect(
          find.byImagePath(Assets.images.button.dpadDown.keyName),
          findsOneWidget,
        );
      });
    });

    group('left', () {
      testWidgets('renders the correct image', (tester) async {
        await tester.pumpButton(
          direction: PinballDpadDirection.left,
          onTap: () {},
        );

        expect(
          find.byImagePath(Assets.images.button.dpadLeft.keyName),
          findsOneWidget,
        );
      });
    });

    group('right', () {
      testWidgets('renders the correct image', (tester) async {
        await tester.pumpButton(
          direction: PinballDpadDirection.right,
          onTap: () {},
        );

        expect(
          find.byImagePath(Assets.images.button.dpadRight.keyName),
          findsOneWidget,
        );
      });
    });
  });
}
