// ignore_for_file: cascade_invocations, one_member_abstracts

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

abstract class _KeyCall {
  bool onCall();
}

class _MockKeyCall extends Mock implements _KeyCall {}

class _MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

RawKeyUpEvent _mockKeyUp(LogicalKeyboardKey key) {
  final event = _MockRawKeyUpEvent();
  when(() => event.logicalKey).thenReturn(key);
  return event;
}

void main() {
  group('KeyboardInputController', () {
    test('calls registered handlers', () {
      final stub = _MockKeyCall();
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
        final stub = _MockKeyCall();
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
        final stub = _MockKeyCall();
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
