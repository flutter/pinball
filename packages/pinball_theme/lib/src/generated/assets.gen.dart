/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesAndroidGen get android => const $AssetsImagesAndroidGen();
  $AssetsImagesDashGen get dash => const $AssetsImagesDashGen();
  $AssetsImagesDinoGen get dino => const $AssetsImagesDinoGen();

  /// File path: assets/images/pinball_button.png
  AssetGenImage get pinballButton =>
      const AssetGenImage('assets/images/pinball_button.png');

  /// File path: assets/images/select_character_background.png
  AssetGenImage get selectCharacterBackground =>
      const AssetGenImage('assets/images/select_character_background.png');

  $AssetsImagesSparkyGen get sparky => const $AssetsImagesSparkyGen();
}

class $AssetsImagesAndroidGen {
  const $AssetsImagesAndroidGen();

  /// File path: assets/images/android/animation.png
  AssetGenImage get animation =>
      const AssetGenImage('assets/images/android/animation.png');

  /// File path: assets/images/android/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/android/background.png');

  /// File path: assets/images/android/character.png
  AssetGenImage get character =>
      const AssetGenImage('assets/images/android/character.png');

  /// File path: assets/images/android/icon.png
  AssetGenImage get icon =>
      const AssetGenImage('assets/images/android/icon.png');

  /// File path: assets/images/android/leaderboard_icon.png
  AssetGenImage get leaderboardIcon =>
      const AssetGenImage('assets/images/android/leaderboard_icon.png');
}

class $AssetsImagesDashGen {
  const $AssetsImagesDashGen();

  /// File path: assets/images/dash/animation.png
  AssetGenImage get animation =>
      const AssetGenImage('assets/images/dash/animation.png');

  /// File path: assets/images/dash/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/dash/background.png');

  /// File path: assets/images/dash/character.png
  AssetGenImage get character =>
      const AssetGenImage('assets/images/dash/character.png');

  /// File path: assets/images/dash/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/dash/icon.png');

  /// File path: assets/images/dash/leaderboard_icon.png
  AssetGenImage get leaderboardIcon =>
      const AssetGenImage('assets/images/dash/leaderboard_icon.png');
}

class $AssetsImagesDinoGen {
  const $AssetsImagesDinoGen();

  /// File path: assets/images/dino/animation.png
  AssetGenImage get animation =>
      const AssetGenImage('assets/images/dino/animation.png');

  /// File path: assets/images/dino/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/dino/background.png');

  /// File path: assets/images/dino/character.png
  AssetGenImage get character =>
      const AssetGenImage('assets/images/dino/character.png');

  /// File path: assets/images/dino/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/images/dino/icon.png');

  /// File path: assets/images/dino/leaderboard_icon.png
  AssetGenImage get leaderboardIcon =>
      const AssetGenImage('assets/images/dino/leaderboard_icon.png');
}

class $AssetsImagesSparkyGen {
  const $AssetsImagesSparkyGen();

  /// File path: assets/images/sparky/animation.png
  AssetGenImage get animation =>
      const AssetGenImage('assets/images/sparky/animation.png');

  /// File path: assets/images/sparky/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/images/sparky/background.png');

  /// File path: assets/images/sparky/character.png
  AssetGenImage get character =>
      const AssetGenImage('assets/images/sparky/character.png');

  /// File path: assets/images/sparky/icon.png
  AssetGenImage get icon =>
      const AssetGenImage('assets/images/sparky/icon.png');

  /// File path: assets/images/sparky/leaderboard_icon.png
  AssetGenImage get leaderboardIcon =>
      const AssetGenImage('assets/images/sparky/leaderboard_icon.png');
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName)
      : super(assetName, package: 'pinball_theme');

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
