// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/backbox/displays/initials_submission_success_display.dart';

void main() {
  group('InitialsSubmissionSuccessDisplay', () {
    final flameTester = FlameTester(Forge2DGame.new);

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, _) async {
        await game.ensureAdd(InitialsSubmissionSuccessDisplay());
      },
      verify: (game, _) async {
        final component = game.firstChild<TextComponent>();
        expect(component, isNotNull);
        expect(component?.text, equals('Success!'));
      },
    );
  });
}
