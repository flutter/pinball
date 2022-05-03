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
    required Points points,
  }) : _points = points;

  final Points _points;

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    gameRef.read<GameBloc>().add(Scored(points: _points.value));
    gameRef.firstChild<ZCanvasComponent>()!.add(
          ScoreComponent(
            points: _points,
            position: other.body.position,
          ),
        );
  }
}

/// {@template bumper_scoring_behavior}
/// A specific [ScoringBehavior] used for Bumpers.
/// In addition to its parent logic, also plays the
/// SFX for bumpers
/// {@endtemplate}
class BumperScoringBehavior extends ScoringBehavior {
  /// {@macro bumper_scoring_behavior}
  BumperScoringBehavior({
    required Points points,
  }) : super(points: points);

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    gameRef.audio.bumper();
  }
}
