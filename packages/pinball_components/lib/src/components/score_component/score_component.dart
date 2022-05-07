import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/score_component/behaviors/score_component_scaling_behavior.dart';
import 'package:pinball_flame/pinball_flame.dart';

enum Points {
  fiveThousand,
  twentyThousand,
  twoHundredThousand,
  oneMillion,
}

/// {@template score_component}
/// A [ScoreComponent] that spawns at a given [position] with a moving
/// animation.
/// {@endtemplate}
class ScoreComponent extends SpriteComponent with HasGameRef, ZIndex {
  /// {@macro score_component}
  ScoreComponent({
    required this.points,
    required Vector2 position,
    required EffectController effectController,
  })  : _effectController = effectController,
        super(
          position: position,
          anchor: Anchor.center,
          children: [ScoreComponentScalingBehavior()],
        ) {
    zIndex = ZIndexes.score;
  }

  /// Creates a [ScoreComponent] without any children.
  ///
  /// This can be used for testing [ScoreComponent]'s behaviors in isolation.
  @visibleForTesting
  ScoreComponent.test({
    required this.points,
    required Vector2 position,
    required EffectController effectController,
  })  : _effectController = effectController,
        super(
          position: position,
          anchor: Anchor.center,
        );

  late Points points;

  late final Effect _effect;

  final EffectController _effectController;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(points.asset),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 55;

    await add(
      _effect = MoveEffect.by(
        Vector2(0, -5),
        _effectController,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_effect.controller.completed) {
      removeFromParent();
    }
  }
}

extension PointsX on Points {
  int get value {
    switch (this) {
      case Points.fiveThousand:
        return 5000;
      case Points.twentyThousand:
        return 20000;
      case Points.twoHundredThousand:
        return 200000;
      case Points.oneMillion:
        return 1000000;
    }
  }
}

extension on Points {
  String get asset {
    switch (this) {
      case Points.fiveThousand:
        return Assets.images.score.fiveThousand.keyName;
      case Points.twentyThousand:
        return Assets.images.score.twentyThousand.keyName;
      case Points.twoHundredThousand:
        return Assets.images.score.twoHundredThousand.keyName;
      case Points.oneMillion:
        return Assets.images.score.oneMillion.keyName;
    }
  }
}
