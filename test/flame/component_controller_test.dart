// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame/src/components/component.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/flame/flame.dart';

class TestComponentController extends ComponentController {
  TestComponentController(Component component) : super(component);
}

class ControlledComponent extends Component
    with Controls<TestComponentController> {
  ControlledComponent() : super() {
    controller = TestComponentController(this);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(FlameGame.new);

  group('ComponentController', () {
    flameTester.test(
      'can  be instantiated',
      (game) async {
        expect(
          TestComponentController(Component()),
          isA<ComponentController>(),
        );
      },
    );

    flameTester.test(
      'throws AssertionError when not attached to controlled component',
      (game) async {
        final component = Component();
        final controller = TestComponentController(component);

        final anotherComponet = Component();
        await expectLater(
          () async => await anotherComponet.add(controller),
          throwsAssertionError,
        );
      },
    );

    flameTester.test(
      'throws Exception when adding a component',
      (game) async {
        final component = ControlledComponent();
        final controller = TestComponentController(component);

        await expectLater(
          () async => controller.add(Component()),
          throwsException,
        );
      },
    );

    flameTester.test(
      'throws Exception when adding multiple components',
      (game) async {
        final component = ControlledComponent();
        final controller = TestComponentController(component);

        await expectLater(
          () async => controller.addAll([
            Component(),
            Component(),
          ]),
          throwsException,
        );
      },
    );
  });

  group('Controls', () {
    flameTester.test(
      'can be instantiated',
      (game) async {
        expect(ControlledComponent(), isA<Component>());
      },
    );

    flameTester.test('adds controller', (game) async {
      final component = ControlledComponent();

      await game.add(component);
      await game.ready();

      expect(component.contains(component.controller), isTrue);
    });
  });
}
