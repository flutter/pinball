/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/ball.png
  AssetGenImage get ball => const AssetGenImage('assets/images/ball.png');

  $AssetsImagesFlipperGen get flipper => const $AssetsImagesFlipperGen();

  /// File path: assets/images/flutter_sign_post.png
  AssetGenImage get flutterSignPost =>
      const AssetGenImage('assets/images/flutter_sign_post.png');

  /// File path: assets/images/spaceship_bridge.png
  AssetGenImage get spaceshipBridge =>
      const AssetGenImage('assets/images/spaceship_bridge.png');

  /// File path: assets/images/spaceship_saucer.png
  AssetGenImage get spaceshipSaucer =>
      const AssetGenImage('assets/images/spaceship_saucer.png');
}

class $AssetsImagesFlipperGen {
  const $AssetsImagesFlipperGen();

  /// File path: assets/images/flipper/left.png
  AssetGenImage get left =>
      const AssetGenImage('assets/images/flipper/left.png');

  /// File path: assets/images/flipper/right.png
  AssetGenImage get right =>
      const AssetGenImage('assets/images/flipper/right.png');
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName)
      : super(assetName, package: 'pinball_components');

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
