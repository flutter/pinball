import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:geometry/geometry.dart' as geometry show centroid;
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/kicker/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/kicker_cubit.dart';

/// {@template kicker}
/// Triangular [BodyType.static] body that propels the [Ball] towards the
/// opposite side.
///
/// [Kicker]s are usually positioned above each [Flipper].
/// {@endtemplate kicker}
class Kicker extends BodyComponent with InitialPosition {
  /// {@macro kicker}
  Kicker({
    required BoardSide side,
    Iterable<Component>? children,
  }) : this._(
          side: side,
          bloc: KickerCubit(),
          children: children,
        );

  Kicker._({
    required BoardSide side,
    required this.bloc,
    Iterable<Component>? children,
  })  : _side = side,
        super(
          children: [
            BumpingBehavior(strength: 25)..applyTo(['bouncy_edge']),
            KickerBallContactBehavior()..applyTo(['bouncy_edge']),
            KickerBlinkingBehavior(),
            _KickerSpriteGroupComponent(
              side: side,
              state: bloc.state,
            ),
            ...?children,
          ],
          renderBody: false,
        );

  /// Creates a [Kicker] without any children.
  ///
  /// This can be used for testing [Kicker]'s behaviors in isolation.
  // TODO(alestiago): Refactor injecting bloc once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  @visibleForTesting
  Kicker.test({
    required this.bloc,
    required BoardSide side,
  }) : _side = side;

  // TODO(alestiago): Consider refactoring once the following is merged:
  // https://github.com/flame-engine/flame/pull/1538
  // ignore: public_member_api_docs
  final KickerCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }

  /// Whether the [Kicker] is on the left or right side of the board.
  final BoardSide _side;

  List<FixtureDef> _createFixtureDefs() {
    final direction = _side.direction;
    const quarterPi = math.pi / 4;
    final size = Vector2(4.4, 15);

    final upperCircle = CircleShape()..radius = 1.6;
    upperCircle.position.setValues(0, upperCircle.radius / 2);

    final lowerCircle = CircleShape()..radius = 1.6;
    lowerCircle.position.setValues(
      size.x * -direction,
      size.y + 0.8,
    );

    final wallFacingEdge = EdgeShape()
      ..set(
        upperCircle.position +
            Vector2(
              upperCircle.radius * direction,
              0,
            ),
        Vector2(2.5 * direction, size.y - 2),
      );

    final bottomEdge = EdgeShape()
      ..set(
        wallFacingEdge.vertex2,
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * direction,
              lowerCircle.radius * math.sin(quarterPi),
            ),
      );

    final bouncyEdge = EdgeShape()
      ..set(
        upperCircle.position +
            Vector2(
              upperCircle.radius * math.cos(quarterPi) * -direction,
              -upperCircle.radius * math.sin(quarterPi),
            ),
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * -direction,
              -lowerCircle.radius * math.sin(quarterPi),
            ),
      );

    final fixturesDefs = [
      FixtureDef(upperCircle),
      FixtureDef(lowerCircle),
      FixtureDef(wallFacingEdge),
      FixtureDef(bottomEdge),
      FixtureDef(bouncyEdge, userData: 'bouncy_edge'),
    ];

    // TODO(alestiago): Evaluate if there is value on centering the fixtures.
    final centroid = geometry.centroid(
      [
        upperCircle.position + Vector2(0, -upperCircle.radius),
        lowerCircle.position +
            Vector2(
              lowerCircle.radius * math.cos(quarterPi) * -direction,
              lowerCircle.radius * math.sin(quarterPi),
            ),
        wallFacingEdge.vertex2,
      ],
    );
    for (final fixtureDef in fixturesDefs) {
      fixtureDef.shape.moveBy(-centroid);
    }

    return fixturesDefs;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
    );
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _KickerSpriteGroupComponent extends SpriteGroupComponent<KickerState>
    with HasGameRef, ParentIsA<Kicker> {
  _KickerSpriteGroupComponent({
    required BoardSide side,
    required KickerState state,
  })  : _side = side,
        super(
          anchor: Anchor.center,
          position: Vector2(0.7 * -side.direction, -2.2),
          current: state,
        );

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    parent.bloc.stream.listen((state) => current = state);

    final sprites = {
      KickerState.lit: Sprite(
        gameRef.images.fromCache(
          (_side.isLeft)
              ? Assets.images.kicker.left.lit.keyName
              : Assets.images.kicker.right.lit.keyName,
        ),
      ),
      KickerState.dimmed: Sprite(
        gameRef.images.fromCache(
          (_side.isLeft)
              ? Assets.images.kicker.left.dimmed.keyName
              : Assets.images.kicker.right.dimmed.keyName,
        ),
      ),
    };
    this.sprites = sprites;
    size = sprites[current]!.originalSize / 10;
  }
}

// TODO(alestiago): Evaluate if there's value on generalising this to
// all shapes.
extension on Shape {
  void moveBy(Vector2 offset) {
    if (this is CircleShape) {
      final circle = this as CircleShape;
      circle.position.setFrom(circle.position + offset);
    } else if (this is EdgeShape) {
      final edge = this as EdgeShape;
      edge.set(edge.vertex1 + offset, edge.vertex2 + offset);
    }
  }
}
