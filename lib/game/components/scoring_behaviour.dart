// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template scoring_behaviour}
///
/// {@endtemplate}
class ScoringBehaviour extends Component
    with
        ContactCallbacksNotifer,
        HasGameRef<PinballGame>,
        ParentIsA<BodyComponent> {
  /// {@macro scoring_behaviour}
  ScoringBehaviour({
    required int points,
  }) : _points = points;

  final int _points;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final userData = parent.body.userData;
    if (userData is ContactCallbacksNotifer) {
      userData.addCallback(this);
    } else {
      parent.body.userData = this;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    gameRef.read<GameBloc>().add(Scored(points: _points));
    gameRef.audio.score();
    gameRef.add(
      ScoreText(
        text: _points.toString(),
        position: other.body.position,
      ),
    );
  }
}