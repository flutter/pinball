// ignore_for_file: public_member_api_docs

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:pinball/gen/gen.dart';

class StarAnimation extends StatelessWidget {
  const StarAnimation._({
    Key? key,
    required this.imagePath,
    required this.columns,
    required this.rows,
    required this.stepTime,
  }) : super(key: key);

  StarAnimation.starA({
    Key? key,
  }) : this._(
          key: key,
          imagePath: Assets.images.selectCharacter.starA.keyName,
          columns: 36,
          rows: 2,
          stepTime: 1 / 18,
        );

  StarAnimation.starB({
    Key? key,
  }) : this._(
          key: key,
          imagePath: Assets.images.selectCharacter.starB.keyName,
          columns: 36,
          rows: 2,
          stepTime: 1 / 36,
        );

  StarAnimation.starC({
    Key? key,
  }) : this._(
          key: key,
          imagePath: Assets.images.selectCharacter.starC.keyName,
          columns: 72,
          rows: 1,
          stepTime: 1 / 24,
        );

  final String imagePath;
  final int columns;
  final int rows;
  final double stepTime;

  static Future<void> loadAssets() {
    Flame.images.prefix = '';

    return Flame.images.loadAll([
      Assets.images.selectCharacter.starA.keyName,
      Assets.images.selectCharacter.starB.keyName,
      Assets.images.selectCharacter.starC.keyName,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: Flame.images.fromCache(imagePath),
      columns: columns,
      rows: rows,
    );
    final animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: stepTime,
      to: spriteSheet.rows * spriteSheet.columns,
    );

    return SizedBox(
      width: 30,
      height: 30,
      child: SpriteAnimationWidget(
        animation: animation,
      ),
    );
  }
}
