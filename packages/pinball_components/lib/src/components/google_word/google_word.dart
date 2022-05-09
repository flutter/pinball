import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

export 'behaviors/behaviors.dart';
export 'cubit/google_word_cubit.dart';

/// {@template google_word}
/// Loads all [GoogleLetter]s to compose a [GoogleWord].
/// {@endtemplate}
class GoogleWord extends PositionComponent {
  /// {@macro google_word}
  GoogleWord({
    required Vector2 position,
  }) : super(
          position: position,
          children: [
            GoogleLetter(0)..position = Vector2(-13.1, 1.72),
            GoogleLetter(1)..position = Vector2(-8.33, -0.75),
            GoogleLetter(2)..position = Vector2(-2.88, -1.85),
            GoogleLetter(3)..position = Vector2(2.88, -1.85),
            GoogleLetter(4)..position = Vector2(8.33, -0.75),
            GoogleLetter(5)..position = Vector2(13.1, 1.72),
          ],
        );
}
