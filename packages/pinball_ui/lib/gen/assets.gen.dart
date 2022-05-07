/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesButtonGen get button => const $AssetsImagesButtonGen();
  $AssetsImagesDialogGen get dialog => const $AssetsImagesDialogGen();
}

class $AssetsImagesButtonGen {
  const $AssetsImagesButtonGen();

  AssetGenImage get dpadDown =>
      const AssetGenImage('assets/images/button/dpad_down.png');
  AssetGenImage get dpadLeft =>
      const AssetGenImage('assets/images/button/dpad_left.png');
  AssetGenImage get dpadRight =>
      const AssetGenImage('assets/images/button/dpad_right.png');
  AssetGenImage get dpadUp =>
      const AssetGenImage('assets/images/button/dpad_up.png');
  AssetGenImage get pinballButton =>
      const AssetGenImage('assets/images/button/pinball_button.png');
}

class $AssetsImagesDialogGen {
  const $AssetsImagesDialogGen();

  AssetGenImage get background =>
      const AssetGenImage('assets/images/dialog/background.png');
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName)
      : super(assetName, package: 'pinball_ui');

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
