import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// {@template blinking_behavior}
/// Looping behavior that performs an action at the end of each loop.
/// {@endtemplate}
class BlinkingBehavior<T> extends Component {
  /// {@macro blinking_behavior}
  BlinkingBehavior({
    required double loopDuration,
    int loops = 1,
    VoidCallback? onLoop,
    VoidCallback? onFinished,
    Stream<T>? stream,
    bool Function(T? previousState, T newState)? listenWhen,
  })  : _loopDuration = loopDuration,
        _loops = loops,
        _onLoop = onLoop,
        _onFinished = onFinished,
        _stream = stream,
        _listenWhen = listenWhen;

  final double _loopDuration;
  final int _loops;
  final VoidCallback? _onLoop;
  final VoidCallback? _onFinished;
  final Stream<T>? _stream;
  final bool Function(T? previousState, T newState)? _listenWhen;

  T? _previousState;
  StreamSubscription<T>? _subscription;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (_stream == null && _listenWhen == null) {
      await add(
        LoopableTimerComponent(
          period: _loopDuration,
          loops: _loops,
          onLoop: _onLoop,
          onFinished: _onFinished,
        )..start(),
      );
      return;
    }
    _subscription = _stream!.listen((newState) async {
      if (_listenWhen!(_previousState, newState)) {
        await add(
          LoopableTimerComponent(
            period: _loopDuration,
            loops: _loops,
            onLoop: _onLoop,
            onFinished: _onFinished,
          )..start(),
        );
      }
      _previousState = newState;
    });
  }

  @override
  void onRemove() {
    _subscription?.cancel();
    super.onRemove();
  }
}

/// {@template loopable_timer_component}
/// Timer that performs an action at the end of each loop.
/// {@endtemplate}
@visibleForTesting
class LoopableTimerComponent extends TimerComponent {
  /// {@macro loopable_timer_component}
  LoopableTimerComponent({
    required double period,
    int loops = 1,
    VoidCallback? onLoop,
    VoidCallback? onFinished,
  })  : _periods = loops,
        _onFinished = onFinished,
        super(
          period: period,
          repeat: true,
          onTick: onLoop,
          autoStart: false,
        );

  final int _periods;

  final VoidCallback? _onFinished;

  int _currentLoop = 0;

  /// Begin the looping.
  void start() => timer.start();

  @override
  void onTick() {
    super.onTick();

    _currentLoop++;
    if (_currentLoop == _periods) {
      timer.stop();
      _onFinished?.call();
      shouldRemove = true;
    }
  }
}
