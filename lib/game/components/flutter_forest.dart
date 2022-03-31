// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template flutter_forest}
/// Area positioned at the top right of the [Board] where the [Ball]
/// can bounce off [DashNestBumper]s.
///
/// When all [DashNestBumper]s are hit at least once, the [GameBonus.dashNest]
/// is awarded, and the [BigDashNestBumper] releases a new [Ball].
/// {@endtemplate}
// TODO(alestiago): Make a [Blueprint] once [Blueprint] inherits from [Component].
class FlutterForest extends Component
    with Controls<FlutterForestController>, HasGameRef<PinballGame> {
  /// {@macro flutter_forest}
  FlutterForest() {
    controller = FlutterForestController(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final signPost = FlutterSignPost()..initialPosition = Vector2(8.35, 58.3);

    final bigNest = ControlledBigDashNestBumper(id: 'big_nest_bumper')
      ..initialPosition = Vector2(18.55, 59.35);
    final smallLeftNest =
        ControlledSmallDashNestBumper.a(id: 'small_nest_bumper_a')
          ..initialPosition = Vector2(8.95, 51.95);
    final smallRightNest =
        ControlledSmallDashNestBumper.b(id: 'small_nest_bumper_b')
          ..initialPosition = Vector2(23.3, 46.75);

    await addAll([
      signPost,
      smallLeftNest,
      smallRightNest,
      bigNest,
    ]);
  }
}

/// {@template flutter_forest_controller}
///
/// {@endtemplate}
class FlutterForestController extends ComponentController<FlutterForest>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  /// {@macro flutter_forest_controller}
  FlutterForestController(FlutterForest flutterForest) : super(flutterForest);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addContactCallback(ControlledDashNestBumperBallContactCallback());
  }

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return (previousState?.bonusHistory.length ?? 0) <
            newState.bonusHistory.length &&
        newState.bonusHistory.last == GameBonus.dashNest;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);

    component.add(
      ControlledBall.bonus(theme: gameRef.theme)
        ..initialPosition = Vector2(17.2, 52.7),
    );
  }
}

/// {@template controlled_big_dash_nest_bumper}
/// A [BigDashNestBumper] controlled by a [DashNestBumperController].
/// {@endtemplate}
class ControlledBigDashNestBumper extends BigDashNestBumper
    with Controls<DashNestBumperController>, ScorePoints {
  /// {@macro controlled_big_dash_nest_bumper}
  ControlledBigDashNestBumper({required String id}) : super() {
    controller = DashNestBumperController(this, id: id);
  }

  @override
  int get points => 20;
}

/// {@template controlled_small_dash_nest_bumper}
/// A [SmallDashNestBumper] controlled by a [DashNestBumperController].
/// {@endtemplate}
class ControlledSmallDashNestBumper extends SmallDashNestBumper
    with Controls<DashNestBumperController>, ScorePoints {
  /// {@macro controlled_small_dash_nest_bumper}
  ControlledSmallDashNestBumper.a({required String id}) : super.a() {
    controller = DashNestBumperController(this, id: id);
  }

  /// {@macro controlled_small_dash_nest_bumper}
  ControlledSmallDashNestBumper.b({required String id}) : super.b() {
    controller = DashNestBumperController(this, id: id);
  }

  @override
  int get points => 10;
}

/// {@template dash_nest_bumper_controller}
/// Controls a [DashNestBumper].
/// {@endtemplate}
class DashNestBumperController extends ComponentController<DashNestBumper>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  /// {@macro dash_nest_bumper_controller}
  DashNestBumperController(
    DashNestBumper dashNestBumper, {
    required String id,
  })  : _id = id,
        super(dashNestBumper);

  /// Unique identifier for the controlled [DashNestBumper].
  ///
  /// Used to identify [DashNestBumper]s in [GameState.activatedDashNests].
  final String _id;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final wasActive = previousState?.activatedDashNests.contains(_id) ?? false;
    final isActive = newState.activatedDashNests.contains(_id);

    return wasActive != isActive;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);

    if (state.activatedDashNests.contains(_id)) {
      component.activate();
    } else {
      component.deactivate();
    }
  }

  /// Registers when a [DashNestBumper] is hit by a [Ball].
  ///
  /// Triggered by [ControlledDashNestBumperBallContactCallback].
  void hit() {
    gameRef.read<GameBloc>().add(DashNestActivated(_id));
  }
}

/// Listens when a [Ball] bounces bounces against a [DashNestBumper]
@visibleForTesting
class ControlledDashNestBumperBallContactCallback
    extends ContactCallback<Controls<DashNestBumperController>, Ball> {
  @override
  void begin(
    Controls<DashNestBumperController> controlledDashNestBumper,
    Ball _,
    Contact __,
  ) {
    controlledDashNestBumper.controller.hit();
  }
}
