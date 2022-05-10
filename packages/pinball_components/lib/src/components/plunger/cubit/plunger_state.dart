part of 'plunger_cubit.dart';

enum PlungerState {
  pulling,

  releasing,

  autopulling,
}

extension PlungerStateX on PlungerState {
  bool get isPulling => this == PlungerState.pulling;
  bool get isReleasing => this == PlungerState.releasing;
  bool get isAutopulling => this == PlungerState.autopulling;
}
