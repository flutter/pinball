// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('DashBumpersState', () {
    test('supports value equality', () {
      expect(
        DashBumpersState(
          bumperSpriteStates: const {
            DashBumperId.main: DashBumperSpriteState.active,
            DashBumperId.a: DashBumperSpriteState.active,
            DashBumperId.b: DashBumperSpriteState.active,
          },
        ),
        equals(
          DashBumpersState(
            bumperSpriteStates: const {
              DashBumperId.main: DashBumperSpriteState.active,
              DashBumperId.a: DashBumperSpriteState.active,
              DashBumperId.b: DashBumperSpriteState.active,
            },
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const DashBumpersState(bumperSpriteStates: {}),
          isNotNull,
        );
      });

      test('initial has all inactive sprite states', () {
        const initialState = DashBumpersState(
          bumperSpriteStates: {
            DashBumperId.main: DashBumperSpriteState.inactive,
            DashBumperId.a: DashBumperSpriteState.inactive,
            DashBumperId.b: DashBumperSpriteState.inactive,
          },
        );

        expect(DashBumpersState.initial(), equals(initialState));
      });
    });

    group('isFullyActivated', () {
      test('returns true when all bumpers have an active state', () {
        const fullyActivatedState = DashBumpersState(
          bumperSpriteStates: {
            DashBumperId.main: DashBumperSpriteState.active,
            DashBumperId.a: DashBumperSpriteState.active,
            DashBumperId.b: DashBumperSpriteState.active,
          },
        );

        expect(fullyActivatedState.isFullyActivated, isTrue);
      });

      test('returns false when not all bumpers have an active state', () {
        const notFullyActivatedState = DashBumpersState(
          bumperSpriteStates: {
            DashBumperId.main: DashBumperSpriteState.active,
            DashBumperId.a: DashBumperSpriteState.active,
            DashBumperId.b: DashBumperSpriteState.inactive,
          },
        );

        expect(notFullyActivatedState.isFullyActivated, isFalse);
      });
    });
  });
}
