// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/backbox/displays/initials_submission_success_display.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('InitialsSubmissionSuccessDisplay', () {
    final flameTester = FlameTester(EmptyKeyboardPinballTestGame.new);

    flameTester.test('renders correctly', (game) async {
      await game.ensureAdd(InitialsSubmissionSuccessDisplay());

      final component = game.firstChild<TextComponent>();
      expect(component, isNotNull);
      expect(component?.text, equals('Success!'));
    });
  });
}
