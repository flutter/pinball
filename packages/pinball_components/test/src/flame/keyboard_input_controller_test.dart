// ignore_for_file: cascade_invocations, one_member_abstracts

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

abstract class _KeyCallStub {
  bool onCall();
}

class KeyCallStub extends Mock implements _KeyCallStub {}

class MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

RawKeyUpEvent _mockKeyUp(LogicalKeyboardKey key) {
  final event = MockRawKeyUpEvent();
  when(() => event.logicalKey).thenReturn(key);
  return event;
}

void main() {
  group('KeyboardInputController', () {
    test('calls registered handlers', () {
      final stub = KeyCallStub();
      when(stub.onCall).thenReturn(true);

      final input = KeyboardInputController(
        keyUp: {
          LogicalKeyboardKey.arrowUp: stub.onCall,
        },
      );

      input.onKeyEvent(_mockKeyUp(LogicalKeyboardKey.arrowUp), {});
      verify(stub.onCall).called(1);
    });

    test(
      'returns false the handler return value',
      () {
        final stub = KeyCallStub();
        when(stub.onCall).thenReturn(false);

        final input = KeyboardInputController(
          keyUp: {
            LogicalKeyboardKey.arrowUp: stub.onCall,
          },
        );

        expect(
          input.onKeyEvent(_mockKeyUp(LogicalKeyboardKey.arrowUp), {}),
          isFalse,
        );
      },
    );

    test(
      'returns true (allowing event to bubble) when no handler is registered',
      () {
        final stub = KeyCallStub();
        when(stub.onCall).thenReturn(true);

        final input = KeyboardInputController();

        expect(
          input.onKeyEvent(_mockKeyUp(LogicalKeyboardKey.arrowUp), {}),
          isTrue,
        );
      },
    );
  });
}
