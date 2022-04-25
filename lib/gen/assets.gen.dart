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
  $AssetsImagesHowToPlayGen get howToPlay => const $AssetsImagesHowToPlayGen();
}

class $AssetsImagesBonusAnimationGen {
  const $AssetsImagesBonusAnimationGen();

  /// File path: assets/images/bonus_animation/android.png
  AssetGenImage get android =>
      const AssetGenImage('assets/images/bonus_animation/android.png');

  /// File path: assets/images/bonus_animation/dash_nest.png
  AssetGenImage get dashNest =>
      const AssetGenImage('assets/images/bonus_animation/dash_nest.png');

  /// File path: assets/images/bonus_animation/dino.png
  AssetGenImage get dino =>
      const AssetGenImage('assets/images/bonus_animation/dino.png');

  /// File path: assets/images/bonus_animation/google.png
  AssetGenImage get google =>
      const AssetGenImage('assets/images/bonus_animation/google.png');

  /// File path: assets/images/bonus_animation/sparky_turbo_charge.png
  AssetGenImage get sparkyTurboCharge => const AssetGenImage(
      'assets/images/bonus_animation/sparky_turbo_charge.png');
}

class $AssetsImagesComponentsGen {
  const $AssetsImagesComponentsGen();

  /// File path: assets/images/components/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/components/background.png');
}

class $AssetsImagesHowToPlayGen {
  const $AssetsImagesHowToPlayGen();

  /// File path: assets/images/how_to_play/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/how_to_play/background.png');

  /// File path: assets/images/how_to_play/down_arrow.png
  AssetGenImage get downArrow =>
      const AssetGenImage('assets/images/how_to_play/down_arrow.png');

  /// File path: assets/images/how_to_play/key_circle.png
  AssetGenImage get keyCircle =>
      const AssetGenImage('assets/images/how_to_play/key_circle.png');

  /// File path: assets/images/how_to_play/left_arrow.png
  AssetGenImage get leftArrow =>
      const AssetGenImage('assets/images/how_to_play/left_arrow.png');

  /// File path: assets/images/how_to_play/right_arrow.png
  AssetGenImage get rightArrow =>
      const AssetGenImage('assets/images/how_to_play/right_arrow.png');

  /// File path: assets/images/how_to_play/space.png
  AssetGenImage get space =>
      const AssetGenImage('assets/images/how_to_play/space.png');
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
