// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template scoring_behavior}
/// Adds points to the score when the ball contacts the [parent].
/// {@endtemplate}
class ScoringBehavior extends ContactBehavior with HasGameRef<PinballGame> {
  /// {@macro scoring_behavior}
  ScoringBehavior({
    required int points,
  }) : _points = points;

  final int _points;

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    gameRef.read<GameBloc>().add(Scored(points: _points));
    gameRef.audio.score();
    gameRef.firstChild<ZCanvasComponent>()!.add(
          ScoreText(
            text: _points.toString(),
            position: other.body.position,
          ),
        );
  }
}
