import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// {@template curve_component}
/// A simple component that runs for the given [duration]
/// following an animation curve.
/// {@endtemplate}
class CurveComponent extends Component {
  /// {@macro curve_component}
  CurveComponent({required this.curve, required this.duration});

  /// Curve of this component
  final Curve curve;

  /// How many seconds this curve lasts
  final double duration;

  double _value = 0;

  final _completer = Completer<void>();

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);

    _value += dt;

    final progress = curve.transform(min(_value, duration) / duration);
    apply(progress);

    if (progress == 1) {
      removeFromParent();
      _completer.complete();
    }
  }

  /// Method called with the proggress (between 0 and 1) of the curve
  /// Override this to apply side effects to the game/components
  void apply(double progress) {}

  /// A future that completes once the curve has completed.
  Future<void> get completed => _completer.future;
}
