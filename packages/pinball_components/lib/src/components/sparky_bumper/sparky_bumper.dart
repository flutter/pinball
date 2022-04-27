import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/sparky_bumper/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/sparky_bumper_cubit.dart';

/// {@template sparky_bumper}
/// Bumper for Sparky area.
/// {@endtemplate}
class SparkyBumper extends BodyComponent with InitialPosition {
  /// {@macro sparky_bumper}
  SparkyBumper._({
    required double majorRadius,
    required double minorRadius,
    required String onAssetPath,
    required String offAssetPath,
    required Vector2 spritePosition,
    required this.bloc,
    Iterable<Component>? children,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          priority: RenderPriority.sparkyBumper,
          renderBody: false,
          children: [
            SparkyBumperBallContactBehavior(),
            SparkyBumperBlinkingBehavior(),
            _SparkyBumperSpriteGroupComponent(
              onAssetPath: onAssetPath,
              offAssetPath: offAssetPath,
              position: spritePosition,
              state: bloc.state,
            ),
            ...?children,
          ],
        );

  /// {@macro sparky_bumper}
  SparkyBumper.a({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 2.9,
          minorRadius: 2.1,
          onAssetPath: Assets.images.sparky.bumper.a.active.keyName,
          offAssetPath: Assets.images.sparky.bumper.a.inactive.keyName,
          spritePosition: Vector2(0, -0.25),
          bloc: SparkyBumperCubit(),
          children: children,
        );

  /// {@macro sparky_bumper}
  SparkyBumper.b({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 2.85,
          minorRadius: 2,
          onAssetPath: Assets.images.sparky.bumper.b.active.keyName,
          offAssetPath: Assets.images.sparky.bumper.b.inactive.keyName,
          spritePosition: Vector2(0, -0.35),
          bloc: SparkyBumperCubit(),
          children: children,
        );

  /// {@macro sparky_bumper}
  SparkyBumper.c({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3,
          minorRadius: 2.2,
          onAssetPath: Assets.images.sparky.bumper.c.active.keyName,
          offAssetPath: Assets.images.sparky.bumper.c.inactive.keyName,
          spritePosition: Vector2(0, -0.4),
          bloc: SparkyBumperCubit(),
          children: children,
        );

  /// Creates an [SparkyBumper] without any children.
  ///
  /// This can be used for testing [SparkyBumper]'s behaviors in isolation.
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  SparkyBumper.test({
    required this.bloc,
  })  : _majorRadius = 3,
        _minorRadius = 2.2;

  final double _majorRadius;
  final double _minorRadius;

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final SparkyBumperCubit bloc;

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
    )..rotate(math.pi / 2.1);
    final fixtureDef = FixtureDef(
      shape,
      restitution: 4,
    );
    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _SparkyBumperSpriteGroupComponent
    extends SpriteGroupComponent<SparkyBumperState>
    with HasGameRef, ParentIsA<SparkyBumper> {
  _SparkyBumperSpriteGroupComponent({
    required String onAssetPath,
    required String offAssetPath,
    required Vector2 position,
    required SparkyBumperState state,
  })  : _onAssetPath = onAssetPath,
        _offAssetPath = offAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
          current: state,
        );

  final String _onAssetPath;
  final String _offAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      SparkyBumperState.active: Sprite(
        gameRef.images.fromCache(_onAssetPath),
      ),
      SparkyBumperState.inactive: Sprite(
        gameRef.images.fromCache(_offAssetPath),
      ),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
