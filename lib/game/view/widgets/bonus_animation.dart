import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template bonus_animation}
/// [Widget] that displays bonus animations.
/// {@endtemplate}
class BonusAnimation extends StatefulWidget {
  /// {@macro bonus_animation}
  const BonusAnimation._(
    String imagePath, {
    VoidCallback? onCompleted,
    Key? key,
  })  : _imagePath = imagePath,
        _onCompleted = onCompleted,
        super(key: key);

  /// [Widget] that displays the dash nest animation.
  BonusAnimation.dashNest({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.dashNest.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  /// [Widget] that displays the sparky turbo charge animation.
  BonusAnimation.sparkyTurboCharge({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.sparkyTurboCharge.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  /// [Widget] that displays the dino chomp animation.
  BonusAnimation.dinoChomp({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.dinoChomp.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  /// [Widget] that displays the android spaceship animation.
  BonusAnimation.androidSpaceship({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.androidSpaceship.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  /// [Widget] that displays the google word animation.
  BonusAnimation.googleWord({
    Key? key,
    VoidCallback? onCompleted,
  }) : this._(
          Assets.images.bonusAnimation.googleWord.keyName,
          onCompleted: onCompleted,
          key: key,
        );

  final String _imagePath;

  final VoidCallback? _onCompleted;

  /// Returns a list of assets to be loaded for animations.
  static List<Future> loadAssets() {
    Flame.images.prefix = '';
    return [
      Flame.images.load(Assets.images.bonusAnimation.dashNest.keyName),
      Flame.images.load(Assets.images.bonusAnimation.sparkyTurboCharge.keyName),
      Flame.images.load(Assets.images.bonusAnimation.dinoChomp.keyName),
      Flame.images.load(Assets.images.bonusAnimation.androidSpaceship.keyName),
      Flame.images.load(Assets.images.bonusAnimation.googleWord.keyName),
    ];
  }

  @override
  State<BonusAnimation> createState() => _BonusAnimationState();
}

class _BonusAnimationState extends State<BonusAnimation>
    with TickerProviderStateMixin {
  late SpriteAnimationController controller;
  late SpriteAnimation animation;
  bool shouldRunBuildCallback = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // When the animation is overwritten by another animation, we need to stop
  // the callback in the build method as it will break the new animation.
  // Otherwise we need to set up a new callback when a new animation starts to
  // show the score view at the end of the animation.
  @override
  void didUpdateWidget(BonusAnimation oldWidget) {
    shouldRunBuildCallback = oldWidget._imagePath == widget._imagePath;

    Future<void>.delayed(
      Duration(seconds: animation.totalDuration().ceil()),
      () {
        widget._onCompleted?.call();
      },
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: Flame.images.fromCache(widget._imagePath),
      columns: 8,
      rows: 9,
    );
    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 1 / 24,
      to: spriteSheet.rows * spriteSheet.columns,
      loop: false,
    );

    Future<void>.delayed(
      Duration(seconds: animation.totalDuration().ceil()),
      () {
        if (shouldRunBuildCallback) {
          widget._onCompleted?.call();
        }
      },
    );

    controller = SpriteAnimationController(
      animation: animation,
      vsync: this,
    )..forward();

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SpriteAnimationWidget(
        controller: controller,
      ),
    );
  }
}
