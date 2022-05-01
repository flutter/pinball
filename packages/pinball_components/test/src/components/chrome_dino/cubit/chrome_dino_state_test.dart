// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('ChromeDinoState', () {
    test('supports value equality', () {
      expect(
        ChromeDinoState(
          status: ChromeDinoStatus.chomping,
          isMouthOpen: true,
        ),
        equals(
          const ChromeDinoState(
            status: ChromeDinoStatus.chomping,
            isMouthOpen: true,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const ChromeDinoState(
            status: ChromeDinoStatus.chomping,
            isMouthOpen: true,
          ),
          isNotNull,
        );
      });

      test('initial is idle with mouth closed', () {
        const initialState = ChromeDinoState(
          status: ChromeDinoStatus.idle,
          isMouthOpen: false,
        );
        expect(ChromeDinoState.inital(), equals(initialState));
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const chromeDinoState = ChromeDinoState(
            status: ChromeDinoStatus.chomping,
            isMouthOpen: true,
          );
          expect(
            chromeDinoState.copyWith(),
            equals(chromeDinoState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          final ball = Ball(baseColor: Colors.red);
          const chromeDinoState = ChromeDinoState(
            status: ChromeDinoStatus.chomping,
            isMouthOpen: true,
          );
          final otherChromeDinoState = ChromeDinoState(
            status: ChromeDinoStatus.idle,
            isMouthOpen: false,
            ball: ball,
          );
          expect(chromeDinoState, isNot(equals(otherChromeDinoState)));

          expect(
            chromeDinoState.copyWith(
              status: ChromeDinoStatus.idle,
              isMouthOpen: false,
              ball: ball,
            ),
            equals(otherChromeDinoState),
          );
        },
      );
    });
  });
}
