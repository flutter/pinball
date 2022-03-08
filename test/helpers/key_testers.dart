import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers.dart';

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
  final event = MockRawKeyUpEvent();
  when(() => event.logicalKey).thenReturn(
    LogicalKeyboardKey.keyA,
  );
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
  final event = MockRawKeyDownEvent();
  when(() => event.logicalKey).thenReturn(
    LogicalKeyboardKey.keyA,
  );
  return event;
}

@isTest
void testRawKeyEvents(
  List<LogicalKeyboardKey> keys,
  Function(RawKeyEvent) test,
) {
  testRawKeyDownEvents(keys, test);
  testRawKeyUpEvents(keys, test);
}
