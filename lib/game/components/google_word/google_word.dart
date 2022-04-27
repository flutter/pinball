import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/components/google_word/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template google_word}
/// Loads all [GoogleLetter]s to compose a [GoogleWord].
/// {@endtemplate}
class GoogleWord extends Component {
  /// {@macro google_word}
  GoogleWord({
    required Vector2 position,
  }) : super(
          children: [
            GoogleLetter(0)..initialPosition = position + Vector2(-12.92, 1.82),
            GoogleLetter(1)..initialPosition = position + Vector2(-8.33, -0.65),
            GoogleLetter(2)..initialPosition = position + Vector2(-2.88, -1.75),
            GoogleLetter(3)..initialPosition = position + Vector2(2.88, -1.75),
            GoogleLetter(4)..initialPosition = position + Vector2(8.33, -0.65),
            GoogleLetter(5)..initialPosition = position + Vector2(12.92, 1.82),
            GoogleWordBonusBehavior(),
          ],
        );

  /// Creates a [GoogleWord] without any children.
  ///
  /// This can be used for testing [GoogleWord]'s behaviors in isolation.
  @visibleForTesting
  GoogleWord.test();
}
