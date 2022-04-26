import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/alien_bumper/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/alien_bumper_cubit.dart';

/// {@template alien_bumper}
/// Bumper for area under the [Spaceship].
/// {@endtemplate}
class AlienBumper extends BodyComponent with InitialPosition {
  /// {@macro alien_bumper}
  AlienBumper._({
    required double majorRadius,
    required double minorRadius,
    required String onAssetPath,
    required String offAssetPath,
    Iterable<Component>? children,
    required this.bloc,
  })  : _majorRadius = majorRadius,
        _minorRadius = minorRadius,
        super(
          priority: RenderPriority.alienBumper,
          children: [
            ContactBehavior(),
            SpriteBehavior(),
            _AlienBumperSpriteGroupComponent(
              offAssetPath: offAssetPath,
              onAssetPath: onAssetPath,
              state: bloc.state,
            ),
            if (children != null) ...children,
          ],
          renderBody: false,
        );

  /// {@macro alien_bumper}
  AlienBumper.a({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.52,
          minorRadius: 2.97,
          onAssetPath: Assets.images.alienBumper.a.active.keyName,
          offAssetPath: Assets.images.alienBumper.a.inactive.keyName,
          bloc: AlienBumperCubit(),
          children: children,
        );

  /// {@macro alien_bumper}
  AlienBumper.b({
    Iterable<Component>? children,
  }) : this._(
          majorRadius: 3.19,
          minorRadius: 2.79,
          onAssetPath: Assets.images.alienBumper.b.active.keyName,
          offAssetPath: Assets.images.alienBumper.b.inactive.keyName,
          bloc: AlienBumperCubit(),
          children: children,
        );

  final double _majorRadius;

  final double _minorRadius;

  // TODO(alestiago): Evaluate testing this.
  final AlienBumperCubit bloc;

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

class _AlienBumperSpriteGroupComponent
    extends SpriteGroupComponent<AlienBumperState>
    with HasGameRef, ParentIsA<AlienBumper> {
  _AlienBumperSpriteGroupComponent({
    required String onAssetPath,
    required String offAssetPath,
    required AlienBumperState state,
  })  : _onAssetPath = onAssetPath,
        _offAssetPath = offAssetPath,
        super(
          anchor: Anchor.center,
          position: Vector2(0, -0.1),
          current: state,
        );

  final String _onAssetPath;
  final String _offAssetPath;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      AlienBumperState.active: Sprite(
        gameRef.images.fromCache(_onAssetPath),
      ),
      AlienBumperState.inactive:
          Sprite(gameRef.images.fromCache(_offAssetPath)),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}