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
// TODO(alestiago): Make a [Blueprint] once [Blueprint] inherits from
// [Component].
class FlutterForest extends Component with Controls<_FlutterForestController> {
  /// {@macro flutter_forest}
  FlutterForest() {
    controller = _FlutterForestController(this);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final signPost = FlutterSignPost()..initialPosition = Vector2(8.35, 58.3);

    final bigNest = _ControlledBigDashNestBumper(
      id: 'big_nest_bumper',
    )..initialPosition = Vector2(18.55, 59.35);
    final smallLeftNest = _ControlledSmallDashNestBumper.a(
      id: 'small_nest_bumper_a',
    )..initialPosition = Vector2(8.95, 51.95);
    final smallRightNest = _ControlledSmallDashNestBumper.b(
      id: 'small_nest_bumper_b',
    )..initialPosition = Vector2(23.3, 46.75);
    final dashAnimatronic = DashAnimatronic()..position = Vector2(20, -66);

    await addAll([
      signPost,
      smallLeftNest,
      smallRightNest,
      bigNest,
      dashAnimatronic,
    ]);
  }
}

class _FlutterForestController extends ComponentController<FlutterForest>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  _FlutterForestController(FlutterForest flutterForest) : super(flutterForest);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.addContactCallback(_ControlledDashNestBumperBallContactCallback());
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

    component.firstChild<DashAnimatronic>()?.playing = true;
    _addBonusBall();
  }

  Future<void> _addBonusBall() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    await gameRef.add(
      ControlledBall.bonus(theme: gameRef.theme)
        ..initialPosition = Vector2(17.2, 52.7),
    );
  }
}

class _ControlledBigDashNestBumper extends BigDashNestBumper
    with Controls<DashNestBumperController>, ScorePoints {
  _ControlledBigDashNestBumper({required String id}) : super() {
    controller = DashNestBumperController(this, id: id);
  }

  @override
  int get points => 20;
}

class _ControlledSmallDashNestBumper extends SmallDashNestBumper
    with Controls<DashNestBumperController>, ScorePoints {
  _ControlledSmallDashNestBumper.a({required String id}) : super.a() {
    controller = DashNestBumperController(this, id: id);
  }

  _ControlledSmallDashNestBumper.b({required String id}) : super.b() {
    controller = DashNestBumperController(this, id: id);
  }

  @override
  int get points => 10;
}

/// {@template dash_nest_bumper_controller}
/// Controls a [DashNestBumper].
/// {@endtemplate}
@visibleForTesting
class DashNestBumperController extends ComponentController<DashNestBumper>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  /// {@macro dash_nest_bumper_controller}
  DashNestBumperController(
    DashNestBumper dashNestBumper, {
    required this.id,
  }) : super(dashNestBumper);

  /// Unique identifier for the controlled [DashNestBumper].
  ///
  /// Used to identify [DashNestBumper]s in [GameState.activatedDashNests].
  final String id;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final wasActive = previousState?.activatedDashNests.contains(id) ?? false;
    final isActive = newState.activatedDashNests.contains(id);

    return wasActive != isActive;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);

    if (state.activatedDashNests.contains(id)) {
      component.activate();
    } else {
      component.deactivate();
    }
  }

  /// Registers when a [DashNestBumper] is hit by a [Ball].
  ///
  /// Triggered by [_ControlledDashNestBumperBallContactCallback].
  void hit() {
    gameRef.read<GameBloc>().add(DashNestActivated(id));
  }
}

/// Listens when a [Ball] bounces bounces against a [DashNestBumper].
class _ControlledDashNestBumperBallContactCallback
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
