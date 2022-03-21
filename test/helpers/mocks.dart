import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/theme/theme.dart';

class MockPinballGame extends Mock implements PinballGame {}

class MockWall extends Mock implements Wall {}

class MockBottomWall extends Mock implements BottomWall {}

class MockBody extends Mock implements Body {}

class MockBall extends Mock implements Ball {}

class MockContact extends Mock implements Contact {}

class MockContactCallback extends Mock
    implements ContactCallback<Object, Object> {}

class MockRampOpening extends Mock implements RampOpening {}

class MockRampOpeningBallContactCallback extends Mock
    implements RampOpeningBallContactCallback {}

class MockGameBloc extends Mock implements GameBloc {}

class MockGameState extends Mock implements GameState {}

class MockThemeCubit extends Mock implements ThemeCubit {}

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

class MockTapUpInfo extends Mock implements TapUpInfo {}

class MockEventPosition extends Mock implements EventPosition {}

class MockBonusLetter extends Mock implements BonusLetter {}

class MockFilter extends Mock implements Filter {}

class MockFixture extends Mock implements Fixture {}

class MockSpaceshipEntrance extends Mock implements SpaceshipEntrance {}

class MockSpaceshipHole extends Mock implements SpaceshipHole {}
