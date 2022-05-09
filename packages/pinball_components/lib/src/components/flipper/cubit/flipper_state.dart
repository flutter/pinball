part of 'flipper_cubit.dart';

enum FlipperState {
  movingDown,
  movingUp,
}

extension FlipperStateX on FlipperState {
  bool get isMovingDown => this == FlipperState.movingDown;
  bool get isMovingUp => this == FlipperState.movingUp;
}
