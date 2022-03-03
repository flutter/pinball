import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

class MockPinballGame extends Mock implements PinballGame {}

class MockWall extends Mock implements Wall {}

class MockBall extends Mock implements Ball {}

class MockContact extends Mock implements Contact {}

class MockGameBloc extends Mock implements GameBloc {}
