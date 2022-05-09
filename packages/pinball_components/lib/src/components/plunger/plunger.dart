import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'behaviors/behaviors.dart';
export 'cubit/plunger_cubit.dart';

/// {@template plunger}
/// [Plunger] serves as a spring, that shoots the ball on the right side of the
/// play field.
///
/// [Plunger] ignores gravity so the player controls its downward movement.
/// {@endtemplate}
class Plunger extends BodyComponent with InitialPosition, Layered, ZIndex {
  /// {@macro plunger}
  Plunger()
      : super(
          renderBody: false,
          children: [
            FlameBlocProvider<PlungerCubit, PlungerState>(
              create: PlungerCubit.new,
              children: [
                _PlungerSpriteAnimationGroupComponent(),
                PlungerReleasingBehavior(strength: 11),
                PlungerNoiseBehavior(),
              ],
            ),
            PlungerJointingBehavior(compressionDistance: 9.2),
          ],
        ) {
    zIndex = ZIndexes.plunger;
    layer = Layer.launcher;
  }

  /// Creates a [Plunger] without any children.
  ///
  /// This can be used for testing [Plunger]'s behaviors in isolation.
  @visibleForTesting
  Plunger.test();

  List<FixtureDef> _createFixtureDefs() {
    final leftShapeVertices = [
      Vector2(0, 0),
      Vector2(-1.8, 0),
      Vector2(-1.8, -2.2),
      Vector2(0, -0.3),
    ]..forEach((vector) => vector.rotate(BoardDimensions.perspectiveAngle));
    final leftTriangleShape = PolygonShape()..set(leftShapeVertices);

    final rightShapeVertices = [
      Vector2(0, 0),
      Vector2(1.8, 0),
      Vector2(1.8, -2.2),
      Vector2(0, -0.3),
    ]..forEach((vector) => vector.rotate(BoardDimensions.perspectiveAngle));
    final rightTriangleShape = PolygonShape()..set(rightShapeVertices);

    return [
      FixtureDef(
        leftTriangleShape,
        density: 80,
      ),
      FixtureDef(
        rightTriangleShape,
        density: 80,
      ),
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      gravityScale: Vector2.zero(),
    );
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _PlungerSpriteAnimationGroupComponent
    extends SpriteAnimationGroupComponent<PlungerState>
    with HasGameRef, FlameBlocListenable<PlungerCubit, PlungerState> {
  _PlungerSpriteAnimationGroupComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(1.87, 14.9),
        );

  @override
  void onNewState(PlungerState state) {
    super.onNewState(state);
    final startedReleasing = state.isReleasing && !current!.isReleasing;
    final startedPulling = state.isPulling && !current!.isPulling;
    if (startedReleasing || startedPulling) {
      animation?.reset();
    }

    current = state;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await gameRef.images.load(
      Assets.images.plunger.plunger.keyName,
    );
    const amountPerRow = 20;
    const amountPerColumn = 1;
    final textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );
    size = textureSize / 10;
    final pullAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: amountPerRow * amountPerColumn ~/ 2,
        amountPerRow: amountPerRow ~/ 2,
        stepTime: 1 / 24,
        textureSize: textureSize,
        texturePosition: Vector2.zero(),
        loop: false,
      ),
    );
    animations = {
      PlungerState.releasing: pullAnimation.reversed(),
      PlungerState.pulling: pullAnimation,
    };

    current = readBloc<PlungerCubit, PlungerState>().state;
  }
}
