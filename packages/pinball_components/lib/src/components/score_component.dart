// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pinball_components/pinball_components.dart';
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
  }) : super(
          position: position,
          anchor: Anchor.center,
        ) {
    zIndex = ZIndexes.score;
  }

  late final Effect _effect;

  late Points points;

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
        EffectController(duration: 1),
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
