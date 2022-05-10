part of 'plunger_cubit.dart';

enum PlungerState {
  pulling,

  releasing,

  autopulling,
}

extension PlungerStateX on PlungerState {
  bool get isPulling =>
      this == PlungerState.pulling || this == PlungerState.autopulling;
  bool get isReleasing => this == PlungerState.releasing;
  bool get isAutoPulling => this == PlungerState.autopulling;
}
