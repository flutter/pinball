import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/dash_bumper/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/dash_bumpers_cubit.dart';

enum DashBumperSpriteState {
  active,
  inactive,
}

enum DashBumperId {
  main,
  a,
  b,
}

/// {@template dash_bumper}
/// Bumper for the flutter forest.
/// {@endtemplate}
class DashBumper extends BodyComponent with InitialPosition {
  /// {@macro dash_bumper}
  DashBumper._({
    required this.id,
    required double majorRadius,
    required double minorRadius,
    required String activeAssetPath,
    required String inactiveAssetPath,
    required Vector2 spritePosition,
    Iterable<Component>? children,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          renderBody: false,
          children: [
            DashBumperSpriteGroupComponent(
              id: id,
              activeAssetPath: activeAssetPath,
              inactiveAssetPath: inactiveAssetPath,
              position: spritePosition,
            ),
            DashBumperBallContactBehavior(),
            ...?children,
          ],
        );

  /// {@macro dash_bumper}
  ///
  /// [DashBumper.main], usually positioned with a [DashAnimatronic] on top of
  /// it.
  DashBumper.main({
    Iterable<Component>? children,
  }) : this._(
          id: DashBumperId.main,
          majorRadius: 5.1,
          minorRadius: 3.75,
          activeAssetPath: Assets.images.dash.bumper.main.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.main.inactive.keyName,
          spritePosition: Vector2(0, -0.3),
          children: [
            ...?children,
            BumpingBehavior(strength: 20),
          ],
        );

  /// {@macro dash_bumper}
  ///
  /// [DashBumper.a] is positioned at the right side of the [DashBumper.main] in
  /// the flutter forest.
  DashBumper.a({
    Iterable<Component>? children,
  }) : this._(
          id: DashBumperId.a,
          majorRadius: 3,
          minorRadius: 2.2,
          activeAssetPath: Assets.images.dash.bumper.a.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.a.inactive.keyName,
          spritePosition: Vector2(0.3, -1.3),
          children: [
            ...?children,
            BumpingBehavior(strength: 20),
          ],
        );

  /// {@macro dash_bumper}
  ///
  /// [DashBumper.b] is positioned at the left side of the [DashBumper.main] in
  /// the flutter forest.
  DashBumper.b({
    Iterable<Component>? children,
  }) : this._(
          id: DashBumperId.b,
          majorRadius: 3.1,
          minorRadius: 2.2,
          activeAssetPath: Assets.images.dash.bumper.b.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.b.inactive.keyName,
          spritePosition: Vector2(0.4, -1.2),
          children: [
            ...?children,
            BumpingBehavior(strength: 20),
          ],
        );

  /// Creates a [DashBumper] without any children.
  ///
  /// This can be used for testing [DashBumper]'s behaviors in isolation.
  @visibleForTesting
  DashBumper.test({required this.id})
      : _majorRadius = 3,
        _minorRadius = 2.5;

  final DashBumperId id;
  final double _majorRadius;
  final double _minorRadius;

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(math.pi / 1.9);
    final bodyDef = BodyDef(
      position: initialPosition,
    );

    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }
}

@visibleForTesting
class DashBumperSpriteGroupComponent
    extends SpriteGroupComponent<DashBumperSpriteState>
    with HasGameRef, FlameBlocListenable<DashBumpersCubit, DashBumpersState> {
  DashBumperSpriteGroupComponent({
    required DashBumperId id,
    required String activeAssetPath,
    required String inactiveAssetPath,
    required Vector2 position,
  })  : _id = id,
        _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
        );

  final DashBumperId _id;
  final String _activeAssetPath;
  final String _inactiveAssetPath;

  @override
  bool listenWhen(DashBumpersState previousState, DashBumpersState newState) {
    return previousState.bumperSpriteStates[_id] !=
        newState.bumperSpriteStates[_id];
  }

  @override
  void onNewState(DashBumpersState state) =>
      current = state.bumperSpriteStates[_id];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprites = {
      DashBumperSpriteState.active:
          Sprite(gameRef.images.fromCache(_activeAssetPath)),
      DashBumperSpriteState.inactive:
          Sprite(gameRef.images.fromCache(_inactiveAssetPath)),
    };
    this.sprites = sprites;
    current = DashBumperSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}
