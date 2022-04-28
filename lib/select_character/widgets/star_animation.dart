import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:pinball/gen/gen.dart';

/// {@template star_animation}
/// Widget to display a looped the star animation.
///
/// For animation is using [SpriteAnimationWidget].
/// {@endtemplate}
class StarAnimation extends StatelessWidget {
  const StarAnimation._({
    Key? key,
    required String imagePath,
    required int columns,
    required int rows,
    required double stepTime,
  })  : _imagePath = imagePath,
        _columns = columns,
        _rows = rows,
        _stepTime = stepTime,
        super(key: key);

  /// [Widget] that displays the star A animation.
  StarAnimation.starA({
    Key? key,
  }) : this._(
          key: key,
          imagePath: Assets.images.selectCharacter.starA.keyName,
          columns: 36,
          rows: 2,
          stepTime: 1 / 18,
        );

  /// [Widget] that displays the star B animation.
  StarAnimation.starB({
    Key? key,
  }) : this._(
          key: key,
          imagePath: Assets.images.selectCharacter.starB.keyName,
          columns: 36,
          rows: 2,
          stepTime: 1 / 36,
        );

  /// [Widget] that displays the star C animation.
  StarAnimation.starC({
    Key? key,
  }) : this._(
          key: key,
          imagePath: Assets.images.selectCharacter.starC.keyName,
          columns: 72,
          rows: 1,
          stepTime: 1 / 24,
        );

  final String _imagePath;
  final int _columns;
  final int _rows;
  final double _stepTime;

  /// Returns a list of assets to be loaded
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
      image: Flame.images.fromCache(_imagePath),
      columns: _columns,
      rows: _rows,
    );
    final animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: _stepTime,
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
