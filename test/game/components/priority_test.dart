// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/components/priority.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class TestBodyComponent extends BodyComponent {
  @override
  Body createBody() {
    final fixtureDef = FixtureDef(CircleShape());
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}

void main() {
  final flameTester = FlameTester(Forge2DGame.new);

  group('ComponentPriorityX', () {
    group('sendToBack', () {
      flameTester.test(
        'changes the priority correctly to board level',
        (game) async {
          final component = TestBodyComponent()..priority = 4;

          await game.ensureAdd(component);
          component.sendToBack();

          expect(component.priority, equals(0));
        },
      );

      flameTester.test(
        'calls reorderChildren if the priority is greater than lowest level',
        (game) async {
          final component = MockComponent();
          when(() => component.priority).thenReturn(4);

          await game.ensureAdd(component);
          component.sendToBack();

          verify(component.reorderChildren).called(1);
        },
      );

      flameTester.test(
        "doesn't call reorderChildren if the priority is the lowest level",
        (game) async {
          final component = MockComponent();
          when(() => component.priority).thenReturn(0);

          await game.ensureAdd(component);
          component.sendToBack();

          verifyNever(component.reorderChildren);
        },
      );
    });

    group('showBehindOf', () {
      flameTester.test(
        'changes the priority if it is greater than other component',
        (game) async {
          const startPriority = 2;
          final component = TestBodyComponent()..priority = startPriority;
          final otherComponent = TestBodyComponent()
            ..priority = startPriority - 1;

          await game.ensureAddAll([component, otherComponent]);
          component.showBehindOf(otherComponent);

          expect(component.priority, equals(otherComponent.priority - 1));
        },
      );

      flameTester.test(
        "doesn't change the priority if it is lower than other component",
        (game) async {
          const startPriority = 2;
          final component = TestBodyComponent()..priority = startPriority;
          final otherComponent = TestBodyComponent()
            ..priority = startPriority + 1;

          await game.ensureAddAll([component, otherComponent]);
          component.showBehindOf(otherComponent);

          expect(component.priority, equals(startPriority));
        },
      );

      flameTester.test(
        'calls reorderChildren if the priority is greater than other component',
        (game) async {
          const startPriority = 2;
          final component = MockComponent();
          final otherComponent = MockComponent();
          when(() => component.priority).thenReturn(startPriority);
          when(() => otherComponent.priority).thenReturn(startPriority - 1);

          await game.ensureAddAll([component, otherComponent]);
          component.showBehindOf(otherComponent);

          verify(component.reorderChildren).called(1);
        },
      );

      flameTester.test(
        "doesn't call reorderChildren if the priority is lower than other "
        'component',
        (game) async {
          const startPriority = 2;
          final component = MockComponent();
          final otherComponent = MockComponent();
          when(() => component.priority).thenReturn(startPriority);
          when(() => otherComponent.priority).thenReturn(startPriority + 1);

          await game.ensureAddAll([component, otherComponent]);
          component.showBehindOf(otherComponent);

          verifyNever(component.reorderChildren);
        },
      );
    });

    group('showInFrontOf', () {
      flameTester.test(
        'changes the priority if it is lower than other component',
        (game) async {
          const startPriority = 2;
          final component = TestBodyComponent()..priority = startPriority;
          final otherComponent = TestBodyComponent()
            ..priority = startPriority + 1;

          await game.ensureAddAll([component, otherComponent]);
          component.showInFrontOf(otherComponent);

          expect(component.priority, equals(otherComponent.priority + 1));
        },
      );

      flameTester.test(
        "doesn't change the priority if it is greater than other component",
        (game) async {
          const startPriority = 2;
          final component = TestBodyComponent()..priority = startPriority;
          final otherComponent = TestBodyComponent()
            ..priority = startPriority - 1;

          await game.ensureAddAll([component, otherComponent]);
          component.showInFrontOf(otherComponent);

          expect(component.priority, equals(startPriority));
        },
      );

      flameTester.test(
        'calls reorderChildren if the priority is lower than other component',
        (game) async {
          const startPriority = 2;
          final component = MockComponent();
          final otherComponent = MockComponent();
          when(() => component.priority).thenReturn(startPriority);
          when(() => otherComponent.priority).thenReturn(startPriority + 1);

          await game.ensureAddAll([component, otherComponent]);
          component.showInFrontOf(otherComponent);

          verify(component.reorderChildren).called(1);
        },
      );

      flameTester.test(
        "doesn't call reorderChildren if the priority is greater than other "
        'component',
        (game) async {
          const startPriority = 2;
          final component = MockComponent();
          final otherComponent = MockComponent();
          when(() => component.priority).thenReturn(startPriority);
          when(() => otherComponent.priority).thenReturn(startPriority - 1);

          await game.ensureAddAll([component, otherComponent]);
          component.showInFrontOf(otherComponent);

          verifyNever(component.reorderChildren);
        },
      );
    });
  });
}
