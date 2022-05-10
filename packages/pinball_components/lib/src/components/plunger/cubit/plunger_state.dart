part of 'plunger_cubit.dart';

enum PlungerState {
  pulling,

  releasing,

  autoPulling,
}

extension PlungerStateX on PlungerState {
  bool get isPulling =>
      this == PlungerState.pulling || this == PlungerState.autoPulling;
  bool get isReleasing => this == PlungerState.releasing;
  bool get isAutoPulling => this == PlungerState.autoPulling;
}
