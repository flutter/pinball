// ignore_for_file: public_member_api_docs

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:pinball/gen/assets.gen.dart';

class BonusAnimation extends StatelessWidget {
  const BonusAnimation._(
    this.imagePath, {
    VoidCallback? onCompleted,
    Key? key,
  })  : _onCompleted = onCompleted,
        super(key: key);

  BonusAnimation.dashNest({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.dashNest.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  BonusAnimation.sparkyTurboCharge({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.sparkyTurboCharge.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  BonusAnimation.dino({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.dino.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  BonusAnimation.android({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.android.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  BonusAnimation.google({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.google.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  final String imagePath;

  final VoidCallback? _onCompleted;

  static Future<void> loadAssets() {
    Flame.images.prefix = '';
    return Flame.images.loadAll([
      Assets.images.bonusAnimation.dashNest.keyName,
      Assets.images.bonusAnimation.sparkyTurboCharge.keyName,
      Assets.images.bonusAnimation.dino.keyName,
      Assets.images.bonusAnimation.android.keyName,
      Assets.images.bonusAnimation.google.keyName,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: Flame.images.fromCache(imagePath),
      columns: 8,
      rows: 9,
    );
    final animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 1 / 24,
      to: spriteSheet.rows * spriteSheet.columns,
      loop: false,
    );

    Future<void>.delayed(
      Duration(seconds: animation.totalDuration().ceil()),
      () {
        _onCompleted?.call();
      },
    );

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SpriteAnimationWidget(
        animation: animation,
      ),
    );
  }
}
