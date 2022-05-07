// ignore_for_file: one_member_abstracts

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_ui/pinball_ui.dart';

extension _WidgetTesterX on WidgetTester {
  Future<void> pumpDpad({
    required VoidCallback onTapUp,
    required VoidCallback onTapDown,
    required VoidCallback onTapLeft,
    required VoidCallback onTapRight,
  }) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MobileDpad(
            onTapUp: onTapUp,
            onTapDown: onTapDown,
            onTapLeft: onTapLeft,
            onTapRight: onTapRight,
          ),
        ),
      ),
    );
  }
}

extension _CommonFindersX on CommonFinders {
  Finder byPinballDpadDirection(PinballDpadDirection direction) {
    return byWidgetPredicate((widget) {
      return widget is PinballDpadButton && widget.direction == direction;
    });
  }
}

abstract class _VoidCallbackStubBase {
  void onCall();
}

class _VoidCallbackStub extends Mock implements _VoidCallbackStubBase {}

void main() {
  group('MobileDpad', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpDpad(
        onTapUp: () {},
        onTapDown: () {},
        onTapLeft: () {},
        onTapRight: () {},
      );

      expect(
        find.byType(PinballDpadButton),
        findsNWidgets(4),
      );
    });

    testWidgets('can tap up', (tester) async {
      final stub = _VoidCallbackStub();
      await tester.pumpDpad(
        onTapUp: stub.onCall,
        onTapDown: () {},
        onTapLeft: () {},
        onTapRight: () {},
      );

      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.up));
      verify(stub.onCall).called(1);
    });

    testWidgets('can tap down', (tester) async {
      final stub = _VoidCallbackStub();
      await tester.pumpDpad(
        onTapUp: () {},
        onTapDown: stub.onCall,
        onTapLeft: () {},
        onTapRight: () {},
      );

      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.down));
      verify(stub.onCall).called(1);
    });

    testWidgets('can tap left', (tester) async {
      final stub = _VoidCallbackStub();
      await tester.pumpDpad(
        onTapUp: () {},
        onTapDown: () {},
        onTapLeft: stub.onCall,
        onTapRight: () {},
      );

      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.left));
      verify(stub.onCall).called(1);
    });

    testWidgets('can tap left', (tester) async {
      final stub = _VoidCallbackStub();
      await tester.pumpDpad(
        onTapUp: () {},
        onTapDown: () {},
        onTapLeft: () {},
        onTapRight: stub.onCall,
      );

      await tester.tap(find.byPinballDpadDirection(PinballDpadDirection.right));
      verify(stub.onCall).called(1);
    });
  });
}
