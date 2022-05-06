// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template scoring_behavior}
/// Adds [_points] to the score and shows a text effect.
///
/// The behavior removes itself after the duration.
/// {@endtemplate}
class ScoringBehavior extends Component
    with HasGameRef, FlameBlocReader<GameBloc, GameState> {
  /// {@macto scoring_behavior}
  ScoringBehavior({
    required Points points,
    required Vector2 position,
    double duration = 1,
  })  : _points = points,
        _position = position,
        _effectController = EffectController(
          duration: duration,
        );

  final Points _points;
  final Vector2 _position;

  final EffectController _effectController;

  @override
  void update(double dt) {
    super.update(dt);
    if (_effectController.completed) {
      removeFromParent();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    bloc.add(Scored(points: _points.value));
    final canvas = gameRef.descendants().whereType<ZCanvasComponent>().single;
    await canvas.add(
      ScoreComponent(
        points: _points,
        position: _position,
        effectController: _effectController,
      ),
    );
  }
}

/// {@template scoring_contact_behavior}
/// Adds points to the score when the [Ball] contacts the [parent].
/// {@endtemplate}
class ScoringContactBehavior extends ContactBehavior {
  /// {@macro scoring_contact_behavior}
  ScoringContactBehavior({
    required Points points,
  }) : _points = points;

  final Points _points;

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    parent.add(
      ScoringBehavior(
        points: _points,
        position: other.body.position,
      ),
    );
  }
}
