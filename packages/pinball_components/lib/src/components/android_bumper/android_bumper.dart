import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_bumper/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/android_bumper_cubit.dart';

/// {@template android_bumper}
/// Bumper for area under the [Spaceship].
/// {@endtemplate}
class AndroidBumper extends BodyComponent with InitialPosition {
  /// {@macro android_bumper}
  AndroidBumper._({
    required double majorRadius,
    required double minorRadius,
    required String litAssetPath,
    required String dimmedAssetPath,
    Iterable<Component>? children,
    required this.bloc,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          priority: RenderPriority.androidBumper,
          renderBody: false,
          children: [
            AndroidBumperBallContactBehavior(),
            AndroidBumperBlinkingBehavior(),
            _AndroidBumperSpriteGroupComponent(
              dimmedAssetPath: dimmedAssetPath,
              litAssetPath: litAssetPath,
              state: bloc.state,
            ),
            ...?children,
          ],
        );

  /// {@macro android_bumper}
  AndroidBumper.a({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.52,
          minorRadius: 2.97,
          litAssetPath: Assets.images.androidBumper.a.lit.keyName,
          dimmedAssetPath: Assets.images.androidBumper.a.dimmed.keyName,
          bloc: AndroidBumperCubit(),
          children: children,
        );

  /// {@macro android_bumper}
  AndroidBumper.b({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.19,
          minorRadius: 2.79,
          litAssetPath: Assets.images.androidBumper.b.lit.keyName,
          dimmedAssetPath: Assets.images.androidBumper.b.dimmed.keyName,
          bloc: AndroidBumperCubit(),
          children: children,
        );

  /// Creates an [AndroidBumper] without any children.
  ///
  /// This can be used for testing [AndroidBumper]'s behaviors in isolation.
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  AndroidBumper.test({
    required this.bloc,
  })  : _majorRadius = 3.52,
        _minorRadius = 2.97;

  final double _majorRadius;

  final double _minorRadius;

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
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
    final fixtureDef = FixtureDef(
      shape,
      restitution: 4,
    );
    final bodyDef = BodyDef(
      position: initialPosition,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _AndroidBumperSpriteGroupComponent
    extends SpriteGroupComponent<AndroidBumperState>
    with HasGameRef, ParentIsA<AndroidBumper> {
  _AndroidBumperSpriteGroupComponent({
    required String litAssetPath,
    required String dimmedAssetPath,
    required AndroidBumperState state,
  })  : _litAssetPath = litAssetPath,
        _dimmedAssetPath = dimmedAssetPath,
        super(
          anchor: Anchor.center,
          position: Vector2(0, -0.1),
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
