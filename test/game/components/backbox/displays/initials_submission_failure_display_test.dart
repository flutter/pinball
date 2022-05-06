// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/backbox/displays/initials_submission_failure_display.dart';

class _TestGame extends Forge2DGame with HasKeyboardHandlerComponents {}

void main() {
  group('InitialsSubmissionFailureDisplay', () {
    final flameTester = FlameTester(_TestGame.new);

    flameTester.test('renders correctly', (game) async {
      await game.ensureAdd(InitialsSubmissionFailureDisplay());

      final component = game.firstChild<TextComponent>();
      expect(component, isNotNull);
      expect(component?.text, equals('Failure!'));
    });
  });
}
