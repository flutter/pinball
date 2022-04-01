// ignore_for_file: cascade_invocations
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/src/flame/priority.dart';

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
    group('sendTo', () {
      flameTester.test(
        'changes the priority correctly to other level',
        (game) async {
          const newPriority = 5;
          final component = TestBodyComponent()..priority = 4;

          component.sendTo(newPriority);

          expect(component.priority, equals(newPriority));
        },
      );

      flameTester.test(
        'calls reorderChildren if the new priority is different',
        (game) async {
          const newPriority = 5;
          final component = MockComponent();
          when(() => component.priority).thenReturn(4);

          component.sendTo(newPriority);

          verify(component.reorderChildren).called(1);
        },
      );

      flameTester.test(
        "doesn't call reorderChildren if the priority is the same",
        (game) async {
          const newPriority = 5;
          final component = MockComponent();
          when(() => component.priority).thenReturn(newPriority);

          component.sendTo(newPriority);

          verifyNever(component.reorderChildren);
        },
      );
    });

    group('sendToBack', () {
      flameTester.test(
        'changes the priority correctly to board level',
        (game) async {
          final component = TestBodyComponent()..priority = 4;

          component.sendToBack();

          expect(component.priority, equals(0));
        },
      );

      flameTester.test(
        'calls reorderChildren if the priority is greater than lowest level',
        (game) async {
          final component = MockComponent();
          when(() => component.priority).thenReturn(4);

          component.sendToBack();

          verify(component.reorderChildren).called(1);
        },
      );

      flameTester.test(
        "doesn't call reorderChildren if the priority is the lowest level",
        (game) async {
          final component = MockComponent();
          when(() => component.priority).thenReturn(0);

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

          component.showInFrontOf(otherComponent);

          verifyNever(component.reorderChildren);
        },
      );
    });
  });
}
