// ignore_for_file: public_member_api_docs
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:pinball_flame/src/rendering/rendering.dart';

mixin Rendering on Component {
  int zIndex = 0;

  @override
  void renderTree(Canvas canvas) {
    if (canvas is PinballCanvas) {
      canvas.buffer(this);
    } else {
      super.renderTree(canvas);
    }
  }
}
