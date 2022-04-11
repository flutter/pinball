// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScoreText', () {
    final flameTester = FlameTester(TestGame.new);

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreText(
            text: '123',
            position: Vector2.zero(),
            color: Colors.white,
          ),
        );
      },
      verify: (game, tester) async {
        final texts = game.descendants().whereType<TextComponent>().length;
        expect(texts, equals(1));
      },
    );

    flameTester.testGameWidget(
      'has a movement effect',
      setUp: (game, tester) async {
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreText(
            text: '123',
            position: Vector2.zero(),
            color: Colors.white,
          ),
        );

        game.update(0.5);
        await tester.pump();
      },
      verify: (game, tester) async {
        final text = game.descendants().whereType<TextComponent>().first;
        expect(text.firstChild<MoveEffect>(), isNotNull);
      },
    );

    flameTester.testGameWidget(
      'is removed once finished',
      setUp: (game, tester) async {
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreText(
            text: '123',
            position: Vector2.zero(),
            color: Colors.white,
          ),
        );

        game.update(1);
        game.update(0); // Ensure all component removals
      },
      verify: (game, tester) async {
        expect(game.children.length, equals(0));
      },
    );
  });
}
