// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template flutter_forest}
/// Area positioned at the top right of the [Board] where the [Ball]
/// can bounce off [DashNestBumper]s.
///
/// When all [DashNestBumper]s are hit at least once, the [GameBonus.dashNest]
/// is awarded, and the [BigDashNestBumper] releases a new [Ball].
/// {@endtemplate}
// TODO(alestiago): Make a [Blueprint] once nesting [Blueprint] is implemented.
class FlutterForest extends Component
    with HasGameRef<PinballGame>, BlocComponent<GameBloc, GameState> {
  /// {@macro flutter_forest}
  FlutterForest({
    required this.position,
  });

  /// The position of the [FlutterForest] on the [Board].
  final Vector2 position;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return (previousState?.bonusHistory.length ?? 0) <
            newState.bonusHistory.length &&
        newState.bonusHistory.last == GameBonus.dashNest;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    gameRef.addFromBlueprint(BallBlueprint(position: position));
  }

  @override
  Future<void> onLoad() async {
    gameRef.addContactCallback(DashNestBumperBallContactCallback());

    // TODO(alestiago): adjust positioning once sprites are added.
    final smallLeftNest = SmallDashNestBumper(id: 'small_left_nest')
      ..initialPosition = position + Vector2(-4.8, 2.8);
    final smallRightNest = SmallDashNestBumper(id: 'small_right_nest')
      ..initialPosition = position + Vector2(0.5, -5.5);
    final bigNest = BigDashNestBumper(id: 'big_nest')
      ..initialPosition = position;

    await addAll([
      smallLeftNest,
      smallRightNest,
      bigNest,
    ]);
  }
}

/// {@template dash_nest_bumper}
/// Bumper located in the [FlutterForest].
/// {@endtemplate}
@visibleForTesting
abstract class DashNestBumper extends BodyComponent<PinballGame>
    with ScorePoints, InitialPosition {
  /// {@macro dash_nest_bumper}
  DashNestBumper({required this.id});

  /// Unique identifier for this [DashNestBumper].
  ///
  /// Used to identify [DashNestBumper]s in [GameState.activatedDashNests].
  final String id;
}

/// Listens when a [Ball] bounces bounces against a [DashNestBumper].
@visibleForTesting
class DashNestBumperBallContactCallback
    extends ContactCallback<DashNestBumper, Ball> {
  @override
  void begin(DashNestBumper dashNestBumper, Ball ball, Contact _) {
    dashNestBumper.gameRef.read<GameBloc>().add(
          DashNestActivated(dashNestBumper.id),
        );
  }
}

/// {@macro dash_nest_bumper}
@visibleForTesting
class BigDashNestBumper extends DashNestBumper {
  /// {@macro dash_nest_bumper}
  BigDashNestBumper({required String id}) : super(id: id);

  @override
  int get points => 20;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 2.5;
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@macro dash_nest_bumper}
@visibleForTesting
class SmallDashNestBumper extends DashNestBumper {
  /// {@macro dash_nest_bumper}
  SmallDashNestBumper({required String id}) : super(id: id);

  @override
  int get points => 10;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1;
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
