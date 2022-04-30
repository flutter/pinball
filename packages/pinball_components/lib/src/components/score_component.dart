// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pinball_components/pinball_components.dart';

enum Score {
  points_5k,
  points_10k,
  points_15k,
  points_20k,
  points_25k,
  points_30k,
  points_40k,
  points_50k,
  points_60k,
  points_80k,
  points_100k,
  points_120k,
  points_200k,
  points_400k,
  points_600k,
  points_800k,
  points_1m,
  points_1m2,
  points_2m,
  points_3m,
  points_4m,
  points_5m,
  points_6m,
}

/// {@template score_component}
/// A [ScoreComponent] that spawns at a given [position] with a moving
/// animation.
/// {@endtemplate}
class ScoreComponent extends SpriteComponent with HasGameRef {
  /// {@macro score_component}
  ScoreComponent({
    required this.score,
    required Vector2 position,
  }) : super(
          position: position,
          anchor: Anchor.center,
          priority: RenderPriority.scoreText,
        );

  late final Effect _effect;

  late Score score;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(score.asset),
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

extension ScoredX on Score {
  int get value {
    switch (this) {
      case Score.points_5k:
        return 5000;
      case Score.points_10k:
        return 10000;
      case Score.points_15k:
        return 15000;
      case Score.points_20k:
        return 20000;
      case Score.points_25k:
        return 25000;
      case Score.points_30k:
        return 30000;
      case Score.points_40k:
        return 40000;
      case Score.points_50k:
        return 50000;
      case Score.points_60k:
        return 60000;
      case Score.points_80k:
        return 80000;
      case Score.points_100k:
        return 100000;
      case Score.points_120k:
        return 120000;
      case Score.points_200k:
        return 200000;
      case Score.points_400k:
        return 400000;
      case Score.points_600k:
        return 600000;
      case Score.points_800k:
        return 800000;
      case Score.points_1m:
        return 1000000;
      case Score.points_1m2:
        return 1200000;
      case Score.points_2m:
        return 2000000;
      case Score.points_3m:
        return 3000000;
      case Score.points_4m:
        return 4000000;
      case Score.points_5m:
        return 5000000;
      case Score.points_6m:
        return 6000000;
    }
  }
}

extension on Score {
  String get asset {
    switch (this) {
      case Score.points_5k:
        return Assets.images.score.points5k.keyName;
      case Score.points_10k:
        return Assets.images.score.points10k.keyName;
      case Score.points_15k:
        return Assets.images.score.points15k.keyName;
      case Score.points_20k:
        return Assets.images.score.points20k.keyName;
      case Score.points_25k:
        return Assets.images.score.points25k.keyName;
      case Score.points_30k:
        return Assets.images.score.points30k.keyName;
      case Score.points_40k:
        return Assets.images.score.points40k.keyName;
      case Score.points_50k:
        return Assets.images.score.points50k.keyName;
      case Score.points_60k:
        return Assets.images.score.points60k.keyName;
      case Score.points_80k:
        return Assets.images.score.points80k.keyName;
      case Score.points_100k:
        return Assets.images.score.points100k.keyName;
      case Score.points_120k:
        return Assets.images.score.points120k.keyName;
      case Score.points_200k:
        return Assets.images.score.points200k.keyName;
      case Score.points_400k:
        return Assets.images.score.points400k.keyName;
      case Score.points_600k:
        return Assets.images.score.points600k.keyName;
      case Score.points_800k:
        return Assets.images.score.points800k.keyName;
      case Score.points_1m:
        return Assets.images.score.points1m.keyName;
      case Score.points_1m2:
        return Assets.images.score.points1m2.keyName;
      case Score.points_2m:
        return Assets.images.score.points2m.keyName;
      case Score.points_3m:
        return Assets.images.score.points3m.keyName;
      case Score.points_4m:
        return Assets.images.score.points4m.keyName;
      case Score.points_5m:
        return Assets.images.score.points5m.keyName;
      case Score.points_6m:
        return Assets.images.score.points6m.keyName;
    }
  }
}
