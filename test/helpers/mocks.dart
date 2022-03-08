import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

class MockPinballGame extends Mock implements PinballGame {}

class MockWall extends Mock implements Wall {}

class MockBottomWall extends Mock implements BottomWall {}

class MockBall extends Mock implements Ball {}

class MockContact extends Mock implements Contact {}

class MockGameBloc extends Mock implements GameBloc {}

class MockRawKeyDownEvent extends Mock implements RawKeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}
