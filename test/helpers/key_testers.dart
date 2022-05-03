import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';

class _MockRawKeyDownEvent extends Mock implements RawKeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

@isTest
void testRawKeyUpEvents(
  List<LogicalKeyboardKey> keys,
  Function(RawKeyUpEvent) test,
) {
  for (final key in keys) {
    test(_mockKeyUpEvent(key));
  }
}

RawKeyUpEvent _mockKeyUpEvent(LogicalKeyboardKey key) {
  final event = _MockRawKeyUpEvent();
  when(() => event.logicalKey).thenReturn(key);
  return event;
}

@isTest
void testRawKeyDownEvents(
  List<LogicalKeyboardKey> keys,
  Function(RawKeyDownEvent) test,
) {
  for (final key in keys) {
    test(_mockKeyDownEvent(key));
  }
}

RawKeyDownEvent _mockKeyDownEvent(LogicalKeyboardKey key) {
  final event = _MockRawKeyDownEvent();
  when(() => event.logicalKey).thenReturn(key);
  return event;
}
