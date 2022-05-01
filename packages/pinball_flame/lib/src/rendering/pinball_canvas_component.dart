// ignore_for_file: public_member_api_docs

import 'dart:ui' show Canvas;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pinball_flame/src/rendering/rendering.dart';

class PinballCanvasComponent extends Component {
  PinballCanvasComponent({
    required Camera camera,
    Iterable<Component>? children,
  })  : _pinballCanvas = PinballCanvas(camera: camera),
        super(children: children);

  final PinballCanvas _pinballCanvas;

  @override
  void renderTree(Canvas canvas) {
    _pinballCanvas.canvas = canvas;
    super.renderTree(_pinballCanvas);
    _pinballCanvas.render();
  }
}
