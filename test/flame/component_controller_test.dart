// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame/src/components/component.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/flame/flame.dart';

class TestComponentController extends ComponentController {
  TestComponentController(Component component) : super(component);
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

    group('attach', () {
      flameTester.test(
        'adds component controller to controlled component',
        (game) async {
          final component = Component();
          final controller = TestComponentController(component);

          await controller.attach();
          await game.add(component);
          await game.ready();

          expect(component.contains(controller), isTrue);
        },
      );

      flameTester.test(
        "doesn't fail when already has a parent",
        (game) async {
          final component = Component();
          final controller = TestComponentController(component);

          await controller.attach();

          await expectLater(
            () async => controller.attach(),
            returnsNormally,
          );
        },
      );
    });
  });
}
