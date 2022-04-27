import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/dash_nest_bumper/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/dash_nest_bumper_cubit.dart';

/// {@template dash_nest_bumper}
/// Bumper with a nest appearance.
/// {@endtemplate}
class DashNestBumper extends BodyComponent with InitialPosition {
  /// {@macro dash_nest_bumper}
  DashNestBumper._({
    required double majorRadius,
    required double minorRadius,
    required String activeAssetPath,
    required String inactiveAssetPath,
    required Vector2 spritePosition,
    Iterable<Component>? children,
    required this.bloc,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          renderBody: false,
          children: [
            _DashNestBumperSpriteGroupComponent(
              activeAssetPath: activeAssetPath,
              inactiveAssetPath: inactiveAssetPath,
              position: spritePosition,
              current: bloc.state,
            ),
            DashNestBumperBallContactBehavior(),
            ...?children,
          ],
        );

  /// {@macro dash_nest_bumper}
  DashNestBumper.main({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 5.1,
          minorRadius: 3.75,
          activeAssetPath: Assets.images.dash.bumper.main.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.main.inactive.keyName,
          spritePosition: Vector2(0, -0.3),
          children: children,
          bloc: DashNestBumperCubit(),
        );

  /// {@macro dash_nest_bumper}
  DashNestBumper.a({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3,
          minorRadius: 2.5,
          activeAssetPath: Assets.images.dash.bumper.a.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.a.inactive.keyName,
          spritePosition: Vector2(0.35, -1.2),
          children: children,
          bloc: DashNestBumperCubit(),
        );

  /// {@macro dash_nest_bumper}
  DashNestBumper.b({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3,
          minorRadius: 2.5,
          activeAssetPath: Assets.images.dash.bumper.b.active.keyName,
          inactiveAssetPath: Assets.images.dash.bumper.b.inactive.keyName,
          spritePosition: Vector2(0.35, -1.2),
          children: children,
          bloc: DashNestBumperCubit(),
        );

  /// Creates an [DashNestBumper] without any children.
  ///
  /// This can be used for testing [DashNestBumper]'s behaviors in isolation.
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  DashNestBumper.test({required this.bloc})
      : _majorRadius = 3,
        _minorRadius = 2.5;

  final double _majorRadius;
  final double _minorRadius;

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final DashNestBumperCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: _majorRadius,
      minorRadius: _minorRadius,
    )..rotate(math.pi / 1.9);
    final fixtureDef = FixtureDef(shape, restitution: 4);
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _DashNestBumperSpriteGroupComponent
    extends SpriteGroupComponent<DashNestBumperState>
    with HasGameRef, ParentIsA<DashNestBumper> {
  _DashNestBumperSpriteGroupComponent({
    required String activeAssetPath,
    required String inactiveAssetPath,
    required Vector2 position,
    required DashNestBumperState current,
  })  : _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
          current: current,
        );

  final String _activeAssetPath;
  final String _inactiveAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      DashNestBumperState.active:
          Sprite(gameRef.images.fromCache(_activeAssetPath)),
      DashNestBumperState.inactive:
          Sprite(gameRef.images.fromCache(_inactiveAssetPath)),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
