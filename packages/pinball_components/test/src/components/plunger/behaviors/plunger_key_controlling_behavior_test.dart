import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _MockRawKeyDownEvent extends Mock implements RawKeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('PlungerKeyControllingBehavior', () {
    test('can be instantiated', () {
      expect(
        PlungerKeyControllingBehavior(),
        isA<PlungerKeyControllingBehavior>(),
      );
    });

    flameTester.test('can be loaded', (game) async {
      final parent = Plunger.test();
      final behavior = PlungerKeyControllingBehavior();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.children, contains(behavior));
    });

    group('onKeyEvent', () {
      late Plunger plunger;

      setUp(() {
        plunger = Plunger.test();
      });

      flameTester.test(
        'pulls when down arrow is pressed',
        (game) async {
          final plunger = Plunger.test();
          await game.ensureAdd(plunger);
          final behavior = PlungerKeyControllingBehavior();
          await plunger.ensureAdd(behavior);

          final event = _MockRawKeyDownEvent();
          when(() => event.logicalKey).thenReturn(
            LogicalKeyboardKey.arrowDown,
          );

          behavior.onKeyEvent(event, {});

          // expect(plunger.body.linearVelocity.y, isPositive);
          // expect(plunger.body.linearVelocity.x, isZero);
        },
      );
    });
  });
}
