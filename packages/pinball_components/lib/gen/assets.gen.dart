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

  $AssetsImagesBaseboardGen get baseboard => const $AssetsImagesBaseboardGen();
  $AssetsImagesChromeDinoGen get chromeDino =>
      const $AssetsImagesChromeDinoGen();
  $AssetsImagesDashBumperGen get dashBumper =>
      const $AssetsImagesDashBumperGen();
  $AssetsImagesDinoGen get dino => const $AssetsImagesDinoGen();
  $AssetsImagesFlipperGen get flipper => const $AssetsImagesFlipperGen();

  /// File path: assets/images/flutter_sign_post.png
  AssetGenImage get flutterSignPost =>
      const AssetGenImage('assets/images/flutter_sign_post.png');

  /// File path: assets/images/spaceship_bridge.png
  AssetGenImage get spaceshipBridge =>
      const AssetGenImage('assets/images/spaceship_bridge.png');

  $AssetsImagesSpaceshipRampGen get spaceshipRamp =>
      const $AssetsImagesSpaceshipRampGen();

  /// File path: assets/images/spaceship_saucer.png
  AssetGenImage get spaceshipSaucer =>
      const AssetGenImage('assets/images/spaceship_saucer.png');
}

class $AssetsImagesBaseboardGen {
  const $AssetsImagesBaseboardGen();

  /// File path: assets/images/baseboard/left.png
  AssetGenImage get left =>
      const AssetGenImage('assets/images/baseboard/left.png');

  /// File path: assets/images/baseboard/right.png
  AssetGenImage get right =>
      const AssetGenImage('assets/images/baseboard/right.png');
}

class $AssetsImagesChromeDinoGen {
  const $AssetsImagesChromeDinoGen();

  /// File path: assets/images/chrome_dino/head.png
  AssetGenImage get head =>
      const AssetGenImage('assets/images/chrome_dino/head.png');

  /// File path: assets/images/chrome_dino/mouth.png
  AssetGenImage get mouth =>
      const AssetGenImage('assets/images/chrome_dino/mouth.png');
}

class $AssetsImagesDashBumperGen {
  const $AssetsImagesDashBumperGen();

  $AssetsImagesDashBumperAGen get a => const $AssetsImagesDashBumperAGen();
  $AssetsImagesDashBumperBGen get b => const $AssetsImagesDashBumperBGen();
  $AssetsImagesDashBumperMainGen get main =>
      const $AssetsImagesDashBumperMainGen();
}

class $AssetsImagesDinoGen {
  const $AssetsImagesDinoGen();

  /// File path: assets/images/dino/dino-land-bottom.png
  AssetGenImage get dinoLandBottom =>
      const AssetGenImage('assets/images/dino/dino-land-bottom.png');

  /// File path: assets/images/dino/dino-land-top.png
  AssetGenImage get dinoLandTop =>
      const AssetGenImage('assets/images/dino/dino-land-top.png');
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

class $AssetsImagesSpaceshipRampGen {
  const $AssetsImagesSpaceshipRampGen();

  /// File path: assets/images/spaceship_ramp/spaceship_drop_tube.png
  AssetGenImage get spaceshipDropTube => const AssetGenImage(
      'assets/images/spaceship_ramp/spaceship_drop_tube.png');

  /// File path: assets/images/spaceship_ramp/spaceship_railing_bg.png
  AssetGenImage get spaceshipRailingBg => const AssetGenImage(
      'assets/images/spaceship_ramp/spaceship_railing_bg.png');

  /// File path: assets/images/spaceship_ramp/spaceship_railing_fg.png
  AssetGenImage get spaceshipRailingFg => const AssetGenImage(
      'assets/images/spaceship_ramp/spaceship_railing_fg.png');

  /// File path: assets/images/spaceship_ramp/spaceship_ramp.png
  AssetGenImage get spaceshipRamp =>
      const AssetGenImage('assets/images/spaceship_ramp/spaceship_ramp.png');
}

class $AssetsImagesDashBumperAGen {
  const $AssetsImagesDashBumperAGen();

  /// File path: assets/images/dash_bumper/a/active.png
  AssetGenImage get active =>
      const AssetGenImage('assets/images/dash_bumper/a/active.png');

  /// File path: assets/images/dash_bumper/a/inactive.png
  AssetGenImage get inactive =>
      const AssetGenImage('assets/images/dash_bumper/a/inactive.png');
}

class $AssetsImagesDashBumperBGen {
  const $AssetsImagesDashBumperBGen();

  /// File path: assets/images/dash_bumper/b/active.png
  AssetGenImage get active =>
      const AssetGenImage('assets/images/dash_bumper/b/active.png');

  /// File path: assets/images/dash_bumper/b/inactive.png
  AssetGenImage get inactive =>
      const AssetGenImage('assets/images/dash_bumper/b/inactive.png');
}

class $AssetsImagesDashBumperMainGen {
  const $AssetsImagesDashBumperMainGen();

  /// File path: assets/images/dash_bumper/main/active.png
  AssetGenImage get active =>
      const AssetGenImage('assets/images/dash_bumper/main/active.png');

  /// File path: assets/images/dash_bumper/main/inactive.png
  AssetGenImage get inactive =>
      const AssetGenImage('assets/images/dash_bumper/main/inactive.png');
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
