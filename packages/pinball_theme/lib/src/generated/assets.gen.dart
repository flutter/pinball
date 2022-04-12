/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/android.png
  AssetGenImage get android => const AssetGenImage('assets/images/android.png');

  /// File path: assets/images/android_background.png
  AssetGenImage get androidBackground =>
      const AssetGenImage('assets/images/android_background.png');

  /// File path: assets/images/android_icon.png
  AssetGenImage get androidIcon =>
      const AssetGenImage('assets/images/android_icon.png');

  /// File path: assets/images/android_placeholder.png
  AssetGenImage get androidPlaceholder =>
      const AssetGenImage('assets/images/android_placeholder.png');

  /// File path: assets/images/dash.png
  AssetGenImage get dash => const AssetGenImage('assets/images/dash.png');

  /// File path: assets/images/dash_background.png
  AssetGenImage get dashBackground =>
      const AssetGenImage('assets/images/dash_background.png');

  /// File path: assets/images/dash_icon.png
  AssetGenImage get dashIcon =>
      const AssetGenImage('assets/images/dash_icon.png');

  /// File path: assets/images/dash_placeholder.png
  AssetGenImage get dashPlaceholder =>
      const AssetGenImage('assets/images/dash_placeholder.png');

  /// File path: assets/images/dino.png
  AssetGenImage get dino => const AssetGenImage('assets/images/dino.png');

  /// File path: assets/images/dino_background.png
  AssetGenImage get dinoBackground =>
      const AssetGenImage('assets/images/dino_background.png');

  /// File path: assets/images/dino_icon.png
  AssetGenImage get dinoIcon =>
      const AssetGenImage('assets/images/dino_icon.png');

  /// File path: assets/images/dino_placeholder.png
  AssetGenImage get dinoPlaceholder =>
      const AssetGenImage('assets/images/dino_placeholder.png');

  /// File path: assets/images/pinball_button.png
  AssetGenImage get pinballButton =>
      const AssetGenImage('assets/images/pinball_button.png');

  /// File path: assets/images/select_character_background.png
  AssetGenImage get selectCharacterBackground =>
      const AssetGenImage('assets/images/select_character_background.png');

  /// File path: assets/images/sparky.png
  AssetGenImage get sparky => const AssetGenImage('assets/images/sparky.png');

  /// File path: assets/images/sparky_background.png
  AssetGenImage get sparkyBackground =>
      const AssetGenImage('assets/images/sparky_background.png');

  /// File path: assets/images/sparky_icon.png
  AssetGenImage get sparkyIcon =>
      const AssetGenImage('assets/images/sparky_icon.png');

  /// File path: assets/images/sparky_placeholder.png
  AssetGenImage get sparkyPlaceholder =>
      const AssetGenImage('assets/images/sparky_placeholder.png');
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
