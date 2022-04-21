// ignore_for_file: public_member_api_docs

import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:pinball/gen/assets.gen.dart';

class BonusAnimation extends StatelessWidget {
  const BonusAnimation._(
    this.imagePath, {
    this.onCompleted,
    Key? key,
  }) : super(key: key);

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

  final String imagePath;

  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    Flame.images.prefix = '';

    // TODO(arturplaczek): Load assets in parent widget, remove future builder
    // and user image from cache.
    return FutureBuilder<Image>(
      future: Flame.images.load(imagePath),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.hasData) {
          final spriteSheet = SpriteSheet.fromColumnsAndRows(
            image: snapshot.data!,
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
              onCompleted?.call();
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

        return const SizedBox();
      },
    );
  }
}
