import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';

class MockPinballGame extends Mock implements PinballGame {}

class MockWall extends Mock implements Wall {}

class MockBottomWall extends Mock implements BottomWall {}

class MockBody extends Mock implements Body {}

class MockBall extends Mock implements Ball {}

class MockControlledBall extends Mock implements ControlledBall {}

class MockBallController extends Mock implements BallController {}

class MockContact extends Mock implements Contact {}

class MockContactCallback extends Mock
    implements ContactCallback<Object, Object> {}

class MockGameBloc extends Mock implements GameBloc {}

class MockStartGameBloc extends Mock implements StartGameBloc {}

class MockGameState extends Mock implements GameState {}

class MockCharacterThemeCubit extends Mock implements CharacterThemeCubit {}

class MockLeaderboardBloc extends Mock implements LeaderboardBloc {}

class MockLeaderboardRepository extends Mock implements LeaderboardRepository {}

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

class MockFilter extends Mock implements Filter {}

class MockFixture extends Mock implements Fixture {}

class MockComponentSet extends Mock implements ComponentSet {}

class MockDashNestBumper extends Mock implements DashNestBumper {}

class MockPinballAudio extends Mock implements PinballAudio {}

class MockSparkyComputerSensor extends Mock implements SparkyComputerSensor {}

class MockAssetsManagerCubit extends Mock implements AssetsManagerCubit {}

class MockBackboard extends Mock implements Backboard {}

class MockCameraController extends Mock implements CameraController {}

class MockActiveOverlaysNotifier extends Mock
    implements ActiveOverlaysNotifier {}

class MockGameFlowController extends Mock implements GameFlowController {}

class MockAlienBumper extends Mock implements AlienBumper {}

class MockSparkyBumper extends Mock implements SparkyBumper {}
