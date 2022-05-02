/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesBonusAnimationGen get bonusAnimation =>
      const $AssetsImagesBonusAnimationGen();
  $AssetsImagesComponentsGen get components =>
      const $AssetsImagesComponentsGen();
  $AssetsImagesScoreGen get score => const $AssetsImagesScoreGen();
}

class $AssetsImagesBonusAnimationGen {
  const $AssetsImagesBonusAnimationGen();

  /// File path: assets/images/bonus_animation/android_spaceship.png
  AssetGenImage get androidSpaceship => const AssetGenImage(
      'assets/images/bonus_animation/android_spaceship.png');

  /// File path: assets/images/bonus_animation/dash_nest.png
  AssetGenImage get dashNest =>
      const AssetGenImage('assets/images/bonus_animation/dash_nest.png');

  /// File path: assets/images/bonus_animation/dino_chomp.png
  AssetGenImage get dinoChomp =>
      const AssetGenImage('assets/images/bonus_animation/dino_chomp.png');

  /// File path: assets/images/bonus_animation/google_word.png
  AssetGenImage get googleWord =>
      const AssetGenImage('assets/images/bonus_animation/google_word.png');

  /// File path: assets/images/bonus_animation/sparky_turbo_charge.png
  AssetGenImage get sparkyTurboCharge => const AssetGenImage(
      'assets/images/bonus_animation/sparky_turbo_charge.png');
}

class $AssetsImagesComponentsGen {
  const $AssetsImagesComponentsGen();

  /// File path: assets/images/components/key.png
  AssetGenImage get key =>
      const AssetGenImage('assets/images/components/key.png');

  /// File path: assets/images/components/space.png
  AssetGenImage get space =>
      const AssetGenImage('assets/images/components/space.png');
}

class $AssetsImagesScoreGen {
  const $AssetsImagesScoreGen();

  /// File path: assets/images/score/mini_score_background.png
  AssetGenImage get miniScoreBackground =>
      const AssetGenImage('assets/images/score/mini_score_background.png');
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
