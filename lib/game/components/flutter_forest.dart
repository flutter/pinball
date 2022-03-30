// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
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

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return (previousState?.bonusHistory.length ?? 0) <
            newState.bonusHistory.length &&
        newState.bonusHistory.last == GameBonus.dashNest;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);

    add(
      ControlledBall.bonus(
        theme: gameRef.theme,
      )..initialPosition = Vector2(17.2, 52.7),
    );
  }

  @override
  Future<void> onLoad() async {
    gameRef.addContactCallback(DashNestBumperBallContactCallback());

    final signPost = FlutterSignPost()..initialPosition = Vector2(8.35, 58.3);

    final bigNest = BigDashNestBumper(id: 'big_nest_bumper')
      ..initialPosition = Vector2(18.55, 59.35);
    final smallLeftNest = SmallDashNestBumper.a(id: 'small_nest_bumper_a')
      ..initialPosition = Vector2(8.95, 51.95);
    final smallRightNest = SmallDashNestBumper.b(id: 'small_nest_bumper_b')
      ..initialPosition = Vector2(23.3, 46.75);

    await addAll([
      signPost,
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
    with ScorePoints, InitialPosition, BlocComponent<GameBloc, GameState> {
  /// {@macro dash_nest_bumper}
  DashNestBumper({
    required this.id,
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  })  : _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        _spriteComponent = spriteComponent;

  /// Unique identifier for this [DashNestBumper].
  ///
  /// Used to identify [DashNestBumper]s in [GameState.activatedDashNests].
  final String id;

  final String _activeAssetPath;
  late final Sprite _activeSprite;
  final String _inactiveAssetPath;
  late final Sprite _inactiveSprite;
  final SpriteComponent _spriteComponent;

  Future<void> _loadSprites() async {
    // TODO(alestiago): I think ideally we would like to do:
    // Sprite(path).load so we don't require to store the activeAssetPath and
    // the inactive assetPath.
    _inactiveSprite = await gameRef.loadSprite(_inactiveAssetPath);
    _activeSprite = await gameRef.loadSprite(_activeAssetPath);
  }

  /// Activates the [DashNestBumper].
  void activate() {
    _spriteComponent.sprite = _activeSprite;
  }

  /// Deactivates the [DashNestBumper].
  void deactivate() {
    _spriteComponent.sprite = _inactiveSprite;
  }

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
      activate();
    } else {
      deactivate();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprites();

    deactivate();
    await add(_spriteComponent);
  }
}

/// Listens when a [Ball] bounces bounces against a [DashNestBumper].
@visibleForTesting
class DashNestBumperBallContactCallback
    extends ContactCallback<DashNestBumper, Ball> {
  @override
  void begin(DashNestBumper dashNestBumper, Ball _, Contact __) {
    dashNestBumper.gameRef.read<GameBloc>().add(
          DashNestActivated(dashNestBumper.id),
        );
  }
}

/// {@macro dash_nest_bumper}
@visibleForTesting
class BigDashNestBumper extends DashNestBumper {
  /// {@macro dash_nest_bumper}
  BigDashNestBumper({required String id})
      : super(
          id: id,
          activeAssetPath: Assets.images.dashBumper.main.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.main.inactive.keyName,
          spriteComponent: SpriteComponent(
            size: Vector2(10.8, 8.6),
            anchor: Anchor.center,
          ),
        );

  @override
  int get points => 20;

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 4.85,
      minorRadius: 3.95,
    )..rotate(math.pi / 2);
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
  SmallDashNestBumper._({
    required String id,
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  }) : super(
          id: id,
          activeAssetPath: activeAssetPath,
          inactiveAssetPath: inactiveAssetPath,
          spriteComponent: spriteComponent,
        );

  /// {@macro dash_nest_bumper}
  SmallDashNestBumper.a({
    required String id,
  }) : this._(
          id: id,
          activeAssetPath: Assets.images.dashBumper.a.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.a.inactive.keyName,
          spriteComponent: SpriteComponent(
            size: Vector2(7.1, 7.5),
            anchor: Anchor.center,
            position: Vector2(0.35, -1.2),
          ),
        );

  /// {@macro dash_nest_bumper}
  SmallDashNestBumper.b({
    required String id,
  }) : this._(
          id: id,
          activeAssetPath: Assets.images.dashBumper.b.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.b.inactive.keyName,
          spriteComponent: SpriteComponent(
            size: Vector2(7.5, 7.4),
            anchor: Anchor.center,
            position: Vector2(0.35, -1.2),
          ),
        );

  @override
  int get points => 10;

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 3,
      minorRadius: 2.25,
    )..rotate(math.pi / 2);
    final fixtureDef = FixtureDef(shape)
      ..friction = 0
      ..restitution = 4;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
