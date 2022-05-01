// ignore_for_file: public_member_api_docs

import 'dart:ui' show Canvas;

import 'package:flame/components.dart';
import 'package:pinball_flame/src/rendering/rendering.dart';

class ZCanvasComponent extends Component {
  ZCanvasComponent({
    Iterable<Component>? children,
  })  : _pinballCanvas = ZCanvas(),
        super(children: children);

  final ZCanvas _pinballCanvas;

  @override
  void renderTree(Canvas canvas) {
    _pinballCanvas.canvas = canvas;
    super.renderTree(_pinballCanvas);
    _pinballCanvas.render();
  }
}
