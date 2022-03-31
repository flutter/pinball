/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesComponentsGen get components =>
      const $AssetsImagesComponentsGen();
}

class $AssetsImagesComponentsGen {
  const $AssetsImagesComponentsGen();

  AssetGenImage get background =>
      const AssetGenImage('assets/images/components/background.png');

  /// File path: assets/images/components/flipper.png
  AssetGenImage get flipper =>
      const AssetGenImage('assets/images/components/flipper.png');

  $AssetsImagesComponentsLaunchRampGen get launchRamp =>
      const $AssetsImagesComponentsLaunchRampGen();

  $AssetsImagesComponentsSpaceshipGen get spaceship =>
      const $AssetsImagesComponentsSpaceshipGen();
}

class $AssetsImagesComponentsLaunchRampGen {
  const $AssetsImagesComponentsLaunchRampGen();

  /// File path: assets/images/components/launch_ramp/launch-ramp.png
  AssetGenImage get launchRamp => const AssetGenImage(
      'assets/images/components/launch_ramp/launch-ramp.png');

  /// File path: assets/images/components/launch_ramp/launch-rail-FG.png
  AssetGenImage get launchRailFG => const AssetGenImage(
      'assets/images/components/launch_ramp/launch-rail-FG.png');
}

class $AssetsImagesComponentsSpaceshipGen {
  const $AssetsImagesComponentsSpaceshipGen();

  /// File path: assets/images/components/spaceship/android-bottom.png
  AssetGenImage get androidBottom => const AssetGenImage(
      'assets/images/components/spaceship/android-bottom.png');

  /// File path: assets/images/components/spaceship/android-top.png
  AssetGenImage get androidTop =>
      const AssetGenImage('assets/images/components/spaceship/android-top.png');

  /// File path: assets/images/components/spaceship/lower.png
  AssetGenImage get lower =>
      const AssetGenImage('assets/images/components/spaceship/lower.png');

  /// File path: assets/images/components/spaceship/saucer.png
  AssetGenImage get saucer =>
      const AssetGenImage('assets/images/components/spaceship/saucer.png');

  /// File path: assets/images/components/spaceship/upper.png
  AssetGenImage get upper =>
      const AssetGenImage('assets/images/components/spaceship/upper.png');
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
