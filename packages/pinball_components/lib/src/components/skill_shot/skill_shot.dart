import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/skill_shot/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/skill_shot_cubit.dart';

/// {@template skill_shot}
/// Rollover awarding extra points.
/// {@endtemplate}
class SkillShot extends BodyComponent with ZIndex {
  /// {@macro skill_shot}
  SkillShot({Iterable<Component>? children})
      : this._(
          children: children,
          bloc: SkillShotCubit(),
        );

  SkillShot._({
    Iterable<Component>? children,
    required this.bloc,
  }) : super(
          renderBody: false,
          children: [
            SkillShotBallContactBehavior(),
            SkillShotBlinkingBehavior(),
            _RolloverDecalSpriteComponent(),
            PinSpriteAnimationComponent(),
            _TextDecalSpriteGroupComponent(state: bloc.state.spriteState),
            ...?children,
          ],
        ) {
    zIndex = ZIndexes.decal;
  }

  /// Creates a [SkillShot] without any children.
  ///
  /// This can be used for testing [SkillShot]'s behaviors in isolation.
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  SkillShot.test({
    required this.bloc,
  });

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final SkillShotCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        0.1,
        3.7,
        Vector2(-31.9, 9.1),
        0.11,
      );
    final fixtureDef = FixtureDef(shape, isSensor: true);
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}

class _RolloverDecalSpriteComponent extends SpriteComponent with HasGameRef {
  _RolloverDecalSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-31.9, 9.1),
          angle: 0.11,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.skillShot.decal.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 20;
  }
}

/// {@template pin_sprite_animation_component}
/// Animation for pin in [SkillShot] rollover.
/// {@endtemplate}
@visibleForTesting
class PinSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef {
  /// {@macro pin_sprite_animation_component}
  PinSpriteAnimationComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-31.9, 9.1),
          angle: 0,
          playing: false,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.skillShot.pin.keyName,
    );

    const amountPerRow = 3;
    const amountPerColumn = 1;
    final textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );
    size = textureSize / 10;

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: amountPerRow * amountPerColumn,
        amountPerRow: amountPerRow,
        stepTime: 1 / 24,
        textureSize: textureSize,
        loop: false,
      ),
    )..onComplete = () {
        animation?.reset();
        playing = false;
      };
  }
}

class _TextDecalSpriteGroupComponent
    extends SpriteGroupComponent<SkillShotSpriteState>
    with HasGameRef, ParentIsA<SkillShot> {
  _TextDecalSpriteGroupComponent({
    required SkillShotSpriteState state,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(-35.55, 3.59),
          current: state,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) => current = state.spriteState);

    final sprites = {
      SkillShotSpriteState.lit: Sprite(
        gameRef.images.fromCache(Assets.images.skillShot.lit.keyName),
      ),
      SkillShotSpriteState.dimmed: Sprite(
        gameRef.images.fromCache(Assets.images.skillShot.dimmed.keyName),
      ),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}
