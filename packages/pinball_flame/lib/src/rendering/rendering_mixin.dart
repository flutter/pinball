// ignore_for_file: public_member_api_docs
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:pinball_flame/src/rendering/rendering.dart';

mixin Rendering on Component {
  int zIndex = 0;

  @override
  void renderTree(
    covariant PinballCanvas canvas,
  ) =>
      canvas.buffer(this);
}
