import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_bumper/behaviors/behaviors.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/android_bumper_cubit.dart';

/// {@template android_bumper}
/// Bumper for area under the [AndroidSpaceship].
/// {@endtemplate}
class AndroidBumper extends BodyComponent with InitialPosition, ZIndex {
  /// {@macro android_bumper}
  AndroidBumper._({
    required double majorRadius,
    required double minorRadius,
    required String litAssetPath,
    required String dimmedAssetPath,
    required Vector2 spritePosition,
    Iterable<Component>? children,
    required this.bloc,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          renderBody: false,
          children: [
            AndroidBumperBallContactBehavior(),
            AndroidBumperBlinkingBehavior(),
            _AndroidBumperSpriteGroupComponent(
              dimmedAssetPath: dimmedAssetPath,
              litAssetPath: litAssetPath,
              position: spritePosition,
              state: bloc.state,
            ),
            ...?children,
          ],
        ) {
    zIndex = ZIndexes.androidBumper;
  }

  /// {@macro android_bumper}
  AndroidBumper.a({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.52,
          minorRadius: 2.97,
          litAssetPath: Assets.images.android.bumper.a.lit.keyName,
          dimmedAssetPath: Assets.images.android.bumper.a.dimmed.keyName,
          spritePosition: Vector2(0, -0.1),
          bloc: AndroidBumperCubit(),
          children: [
            ...?children,
            BumpingBehavior(strength: 20),
          ],
        );

  /// {@macro android_bumper}
  AndroidBumper.b({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.19,
          minorRadius: 2.79,
          litAssetPath: Assets.images.android.bumper.b.lit.keyName,
          dimmedAssetPath: Assets.images.android.bumper.b.dimmed.keyName,
          spritePosition: Vector2(0, -0.1),
          bloc: AndroidBumperCubit(),
          children: [
            ...?children,
            BumpingBehavior(strength: 20),
          ],
        );

  /// {@macro android_bumper}
  AndroidBumper.cow({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.45,
          minorRadius: 3.11,
          litAssetPath: Assets.images.android.bumper.cow.lit.keyName,
          dimmedAssetPath: Assets.images.android.bumper.cow.dimmed.keyName,
          spritePosition: Vector2(0, -0.35),
          bloc: AndroidBumperCubit(),
          children: [
            ...?children,
            BumpingBehavior(strength: 20),
          ],
        );

  /// Creates an [AndroidBumper] without any children.
  ///
  /// This can be used for testing [AndroidBumper]'s behaviors in isolation.
  @visibleForTesting
  AndroidBumper.test({
    required this.bloc,
  })  : _majorRadius = 3.52,
        _minorRadius = 2.97;

  final double _majorRadius;

  final double _minorRadius;

  final AndroidBumperCubit bloc;

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
    )..rotate(1.29);
    final bodyDef = BodyDef(
      position: initialPosition,
    );

    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }
}

class _AndroidBumperSpriteGroupComponent
    extends SpriteGroupComponent<AndroidBumperState>
    with HasGameRef, ParentIsA<AndroidBumper> {
  _AndroidBumperSpriteGroupComponent({
    required String litAssetPath,
    required String dimmedAssetPath,
    required Vector2 position,
    required AndroidBumperState state,
  })  : _litAssetPath = litAssetPath,
        _dimmedAssetPath = dimmedAssetPath,
        super(
          anchor: Anchor.center,
          position: position,
          current: state,
        );

  final String _litAssetPath;
  final String _dimmedAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      AndroidBumperState.lit: Sprite(
        gameRef.images.fromCache(_litAssetPath),
      ),
      AndroidBumperState.dimmed:
          Sprite(gameRef.images.fromCache(_dimmedAssetPath)),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
