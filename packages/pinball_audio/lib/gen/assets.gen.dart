/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsMusicGen {
  const $AssetsMusicGen();

  String get background => 'assets/music/background.mp3';
}

class $AssetsSfxGen {
  const $AssetsSfxGen();

  String get android => 'assets/sfx/android.mp3';
  String get bumperA => 'assets/sfx/bumper_a.mp3';
  String get bumperB => 'assets/sfx/bumper_b.mp3';
  String get cowMoo => 'assets/sfx/cow_moo.mp3';
  String get dash => 'assets/sfx/dash.mp3';
  String get dino => 'assets/sfx/dino.mp3';
  String get gameOverVoiceOver => 'assets/sfx/game_over_voice_over.mp3';
  String get google => 'assets/sfx/google.mp3';
  String get ioPinballVoiceOver => 'assets/sfx/io_pinball_voice_over.mp3';
  String get kickerA => 'assets/sfx/kicker_a.mp3';
  String get kickerB => 'assets/sfx/kicker_b.mp3';
  String get launcher => 'assets/sfx/launcher.mp3';
  String get rollover => 'assets/sfx/rollover.mp3';
  String get sparky => 'assets/sfx/sparky.mp3';
}

class Assets {
  Assets._();

  static const $AssetsMusicGen music = $AssetsMusicGen();
  static const $AssetsSfxGen sfx = $AssetsSfxGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName)
      : super(assetName, package: 'pinball_audio');

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
